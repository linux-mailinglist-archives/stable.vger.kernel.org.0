Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD9C3D5D62
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235447AbhGZPBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235367AbhGZPBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:01:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39116604DC;
        Mon, 26 Jul 2021 15:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314095;
        bh=Mxcu6ZoSFLi/nLaZ8Wrf0RDQDHnxD3Pp8+kBXYmDzxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oy+gkKtJKh5FSdU5IG59jsL9YrnXKl5F35dULyfkG4MvJj8DjhOfniH5iUTOdjIQP
         bVs6XGynBDzlwBAvQAE2jEKB/StMAigpnyw9fBzNwBu4GgrBtvM+nVZQFWRXQO1aK8
         6tdyKa779OdQH7ssJdRlosp0hlailaXn+flZE2W0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 09/47] Revert "memory: fsl_ifc: fix leak of IO mapping on probe failure"
Date:   Mon, 26 Jul 2021 17:38:27 +0200
Message-Id: <20210726153823.276462469@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153822.980271128@linuxfoundation.org>
References: <20210726153822.980271128@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit b7a2bcb4a3731d68f938207f75ed3e1d41774510 which is
commit 3b132ab67fc7a358fff35e808fa65d4bea452521 upstream.

As reported, it breaks the build, the 'gregs' field is not in the 4.4.y
kernel tree.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20210721144845.GA3445926@roeck-us.net
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memory/fsl_ifc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/memory/fsl_ifc.c
+++ b/drivers/memory/fsl_ifc.c
@@ -228,7 +228,8 @@ static int fsl_ifc_ctrl_probe(struct pla
 	fsl_ifc_ctrl_dev->regs = of_iomap(dev->dev.of_node, 0);
 	if (!fsl_ifc_ctrl_dev->regs) {
 		dev_err(&dev->dev, "failed to get memory region\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err;
 	}
 
 	version = ifc_in32(&fsl_ifc_ctrl_dev->regs->ifc_rev) &
@@ -305,7 +306,6 @@ err_irq:
 	free_irq(fsl_ifc_ctrl_dev->irq, fsl_ifc_ctrl_dev);
 	irq_dispose_mapping(fsl_ifc_ctrl_dev->irq);
 err:
-	iounmap(fsl_ifc_ctrl_dev->gregs);
 	return ret;
 }
 


