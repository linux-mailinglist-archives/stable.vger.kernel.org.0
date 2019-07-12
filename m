Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0752F66E41
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbfGLMbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729328AbfGLMbO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:31:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A26992166E;
        Fri, 12 Jul 2019 12:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934674;
        bh=vUf3XpGa+WekQ5lIiG92xQn8VR8/MuKJgGBSwBLnhYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5gwlWIs9VTLRDvjjX/OPSEXVRM3tWhQkHy908Q8lWK48QaWgHkKImCGcmFKJyiTD
         mgrzun9f1OXuxVu3ihmKd7bxYrBXgszgkahFvFRLlcgJWUjvTGlI+JLC3E5qba5UfX
         3gauOz+2XVbZH7+4s991yOsWyzvOxnFDaMp0tFc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 5.1 133/138] staging: fsl-dpaa2/ethsw: fix memory leak of switchdev_work
Date:   Fri, 12 Jul 2019 14:19:57 +0200
Message-Id: <20190712121633.820876009@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 5555ebbbac822b4fa28db2be15aaf98b3c21af26 upstream.

In the default event case switchdev_work is being leaked because
nothing is queued for work. Fix this by kfree'ing switchdev_work
before returning NOTIFY_DONE.

Addresses-Coverity: ("Resource leak")
Fixes: 44baaa43d7cc ("staging: fsl-dpaa2/ethsw: Add Freescale DPAA2 Ethernet Switch driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -1086,6 +1086,7 @@ static int port_switchdev_event(struct n
 		dev_hold(dev);
 		break;
 	default:
+		kfree(switchdev_work);
 		return NOTIFY_DONE;
 	}
 


