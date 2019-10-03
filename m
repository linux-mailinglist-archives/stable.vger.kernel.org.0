Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26309CA9E2
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392368AbfJCRBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404740AbfJCQpE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:45:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26C962070B;
        Thu,  3 Oct 2019 16:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121103;
        bh=d6AmPNfDAj8KGd/fgbph9jyrUnZ5/VpvIL6yT6NRvUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKpUM0bqzt2zEC6HE6g9EIbKPJhZZjtEuUPEhdrv9UCHdaqRSw11WCL5WbG7tK7U2
         h+MABdo/NfLoaYSYFYLcnxlcpgHyDFMA/zYQkHNwXMZWx0x1T73OA6xo2YoethDYa1
         8sZ5MvKydIzJ2Rr1IkOwmKTkiJX9sSA0O5paMAq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 156/344] media: cec-notifier: clear cec_adap in cec_notifier_unregister
Date:   Thu,  3 Oct 2019 17:52:01 +0200
Message-Id: <20191003154555.622936762@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 14d5511691e5290103bc480998bc322e68f139d4 ]

If cec_notifier_cec_adap_unregister() is called before
cec_unregister_adapter() then everything is OK (and this is the
case today). But if it is the other way around, then
cec_notifier_unregister() is called first, and that doesn't
set n->cec_adap to NULL.

So if e.g. cec_notifier_set_phys_addr() is called after
cec_notifier_unregister() but before cec_unregister_adapter()
then n->cec_adap points to an unregistered and likely deleted
cec adapter. So just set n->cec_adap->notifier and n->cec_adap
to NULL for rubustness.

Eventually cec_notifier_unregister will disappear and this will
be simplified substantially.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/cec-notifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/cec/cec-notifier.c b/drivers/media/cec/cec-notifier.c
index 52a867bde15fd..4d82a5522072e 100644
--- a/drivers/media/cec/cec-notifier.c
+++ b/drivers/media/cec/cec-notifier.c
@@ -218,6 +218,8 @@ void cec_notifier_unregister(struct cec_notifier *n)
 
 	mutex_lock(&n->lock);
 	n->callback = NULL;
+	n->cec_adap->notifier = NULL;
+	n->cec_adap = NULL;
 	mutex_unlock(&n->lock);
 	cec_notifier_put(n);
 }
-- 
2.20.1



