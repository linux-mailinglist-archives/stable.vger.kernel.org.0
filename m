Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCFA2596C5
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgIAPk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbgIAPkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:40:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C798205F4;
        Tue,  1 Sep 2020 15:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974823;
        bh=6ceRjbOi00aeiPyiExOHXrxLa2Uo8I/yzUXIHx6fLpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkTKIcSnr94wfda9H7fqmNLzgVG7KtEgt06todWGkwuF/C8g90WobmaXWScKX1O+g
         NPi3XkGgsQwt/l9w/Rm2XMjq8CGb81sQ8fkCjjDLRW/0mP35DYP7xozxi+NJZ5wbYZ
         4vOnq28WfRmS2uIqvgwYcTbWQfavcKOFfwXQuU2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 104/255] usb: gadget: f_tcm: Fix some resource leaks in some error paths
Date:   Tue,  1 Sep 2020 17:09:20 +0200
Message-Id: <20200901151005.696699394@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 07c8434150f4eb0b65cae288721c8af1080fde17 ]

If a memory allocation fails within a 'usb_ep_alloc_request()' call, the
already allocated memory must be released.

Fix a mix-up in the code and free the correct requests.

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_tcm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index eaf556ceac32b..0a45b4ef66a67 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -753,12 +753,13 @@ static int uasp_alloc_stream_res(struct f_uas *fu, struct uas_stream *stream)
 		goto err_sts;
 
 	return 0;
+
 err_sts:
-	usb_ep_free_request(fu->ep_status, stream->req_status);
-	stream->req_status = NULL;
-err_out:
 	usb_ep_free_request(fu->ep_out, stream->req_out);
 	stream->req_out = NULL;
+err_out:
+	usb_ep_free_request(fu->ep_in, stream->req_in);
+	stream->req_in = NULL;
 out:
 	return -ENOMEM;
 }
-- 
2.25.1



