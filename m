Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250FA1F2E36
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbgFIAjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:32904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727000AbgFHXNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2820021501;
        Mon,  8 Jun 2020 23:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657991;
        bh=jToSYFS2vOMZ5n1wXwwMj/jz/gA41gucPfwOiuHznQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFFreVBz/tqfg63N5qSO7+Iqor9MN0d0WxHNZWlmtAyhTPmRZz/3nRzGJRMLzO6CR
         dZa7gne1KMotqJ8NBkWbQVDFqK+FltoS4sywUD1PDsGwespxwCxMx4hAaBUHuKBLf3
         46xqzah11To64YyZ0zikqfJEbgTDJViGgb1JQqNE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 050/606] usb: gadget: net2272: Fix a memory leak in an error handling path in 'net2272_plat_probe()'
Date:   Mon,  8 Jun 2020 19:02:55 -0400
Message-Id: <20200608231211.3363633-50-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit ccaef7e6e354fb65758eaddd3eae8065a8b3e295 upstream.

'dev' is allocated in 'net2272_probe_init()'. It must be freed in the error
handling path, as already done in the remove function (i.e.
'net2272_plat_remove()')

Fixes: 90fccb529d24 ("usb: gadget: Gadget directory cleanup - group UDC drivers")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/net2272.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/udc/net2272.c b/drivers/usb/gadget/udc/net2272.c
index a8273b589456..5af0fe9c61d7 100644
--- a/drivers/usb/gadget/udc/net2272.c
+++ b/drivers/usb/gadget/udc/net2272.c
@@ -2647,6 +2647,8 @@ net2272_plat_probe(struct platform_device *pdev)
  err_req:
 	release_mem_region(base, len);
  err:
+	kfree(dev);
+
 	return ret;
 }
 
-- 
2.25.1

