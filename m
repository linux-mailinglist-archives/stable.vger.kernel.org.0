Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7372630CB71
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239522AbhBBTYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:24:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233025AbhBBN75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:59:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B9DE64F7D;
        Tue,  2 Feb 2021 13:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273609;
        bh=XxQAYyRfuA0Bl35YaHVLxWvct+tsUTm/eunosjpt6ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xda2/TTKBaDEWwMHWntXJisKby/gK7J7PxwcnESqEk/+t7pqwPbUHmdmIowZBKjKb
         zG3bfvMWXphf+FkuCR9agp+cpO8zhirsPTiYoLIZe/wvAZXn7zTRJAi1h5tDBVPbTJ
         i6fq6zaun+7IaR4KtlumjRWjzKMaV4Qve49BBvOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.4 27/61] drm/nouveau/svm: fail NOUVEAU_SVM_INIT ioctl on unsupported devices
Date:   Tue,  2 Feb 2021 14:38:05 +0100
Message-Id: <20210202132947.614228114@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
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
@@ -306,6 +306,10 @@ nouveau_svmm_init(struct drm_device *dev
 	struct drm_nouveau_svm_init *args = data;
 	int ret;
 
+	/* We need to fail if svm is disabled */
+	if (!cli->drm->svm)
+		return -ENOSYS;
+
 	/* Allocate tracking for SVM-enabled VMM. */
 	if (!(svmm = kzalloc(sizeof(*svmm), GFP_KERNEL)))
 		return -ENOMEM;


