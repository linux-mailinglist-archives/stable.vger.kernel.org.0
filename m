Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284DB419CC7
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbhI0RcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:32:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238753AbhI0RaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:30:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 034056152A;
        Mon, 27 Sep 2021 17:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763099;
        bh=mNv1iCDFt7uB3G4JqbQOvDKcJhdc47B8sWNX4D3lOrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3Hx5ft7Ayyu9EFvgmhR8k7zaUqIhQzPrBdLjox0Q474I3jwallUfZC7H8lfcplWl
         LgrxdykV5FWciYTdIR4ch8kgkeP352V/wJzOA5EUylPKIZ2HItDap/uELXJwmHRWic
         KEDxmA0MMga8h8oOBsRp4LG4VC48zt+hYXA66/nc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.14 160/162] nvmet: fix a width vs precision bug in nvmet_subsys_attr_serial_show()
Date:   Mon, 27 Sep 2021 19:03:26 +0200
Message-Id: <20210927170238.966549961@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 0bd46e22c5ec3dbfb81b60de475151e3f6b411c2 upstream.

This was intended to limit the number of characters printed from
"subsys->serial" to NVMET_SN_MAX_SIZE.  But accidentally the width
specifier was used instead of the precision specifier so it only
affects the alignment and not the number of characters printed.

Fixes: f04064814c2a ("nvmet: fixup buffer overrun in nvmet_subsys_attr_serial()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/configfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1067,7 +1067,7 @@ static ssize_t nvmet_subsys_attr_serial_
 {
 	struct nvmet_subsys *subsys = to_subsys(item);
 
-	return snprintf(page, PAGE_SIZE, "%*s\n",
+	return snprintf(page, PAGE_SIZE, "%.*s\n",
 			NVMET_SN_MAX_SIZE, subsys->serial);
 }
 


