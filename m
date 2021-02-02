Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FE430C01B
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhBBNtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:49:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232742AbhBBNrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:47:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E33A864F95;
        Tue,  2 Feb 2021 13:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273312;
        bh=3tsrlpPeSYjCRQFX/Kko3V86vLDgJBvIC0KszJLfEng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zfFN21vlqYW0ZeEBk0WG484L7DVlBlYftEG/COh/WIHd6Hbzsd5tGWWVQbdkUw4k0
         XIFxGHZNTASpGg5S+uiHA1Ngwo7EJliaUU9ay+Y2TJdvtAbnUVEXX+9uZKBdIZcKva
         nwxnlhNMhgSrazAY5GLxcTVhRUqs7laZc1rPOICw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.10 059/142] drm/nouveau/svm: fail NOUVEAU_SVM_INIT ioctl on unsupported devices
Date:   Tue,  2 Feb 2021 14:37:02 +0100
Message-Id: <20210202133000.153752372@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karol Herbst <kherbst@redhat.com>

commit dcd602cc5fe2803bf532d407cde24ba0b7808ff3 upstream.

Fixes a crash when trying to create a channel on e.g. Turing GPUs when
NOUVEAU_SVM_INIT was called before.

Fixes: eeaf06ac1a558 ("drm/nouveau/svm: initial support for shared virtual memory")
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_svm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -315,6 +315,10 @@ nouveau_svmm_init(struct drm_device *dev
 	struct drm_nouveau_svm_init *args = data;
 	int ret;
 
+	/* We need to fail if svm is disabled */
+	if (!cli->drm->svm)
+		return -ENOSYS;
+
 	/* Allocate tracking for SVM-enabled VMM. */
 	if (!(svmm = kzalloc(sizeof(*svmm), GFP_KERNEL)))
 		return -ENOMEM;


