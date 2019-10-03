Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7FA9CA8A9
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391719AbfJCQaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:30:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391694AbfJCQaU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:30:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51B4E2054F;
        Thu,  3 Oct 2019 16:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120219;
        bh=xEyFGuV9urV2Izp0x4mN7WNWUY36GjkjKfAmNsiu/P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFwL/2MbxxVHvTUQvgAwgqWCkjDfn21dfeA08XIyNm+ojcgfUOaTRpZk6zqcVQH1O
         uPadrv7JF758cVw6nR/dc+Xh9VV9CcB9KlE7NhtUceEQVIM8nG3vCuMgx89T0PZS0x
         hmtADn7xy2LpNVnSyvWMHXrxkdGXyLJT+bASCWW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 141/313] media: cec-notifier: clear cec_adap in cec_notifier_unregister
Date:   Thu,  3 Oct 2019 17:51:59 +0200
Message-Id: <20191003154546.767772799@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
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
index 9598c7778871a..c4aa27e0c4308 100644
--- a/drivers/media/cec/cec-notifier.c
+++ b/drivers/media/cec/cec-notifier.c
@@ -124,6 +124,8 @@ void cec_notifier_unregister(struct cec_notifier *n)
 {
 	mutex_lock(&n->lock);
 	n->callback = NULL;
+	n->cec_adap->notifier = NULL;
+	n->cec_adap = NULL;
 	mutex_unlock(&n->lock);
 	cec_notifier_put(n);
 }
-- 
2.20.1



