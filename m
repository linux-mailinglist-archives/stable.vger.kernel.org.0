Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AD92A57BC
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732148AbgKCUwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:52:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732154AbgKCUws (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCD172053B;
        Tue,  3 Nov 2020 20:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436768;
        bh=pB7QqlUSUS5TIZ5kW+2Hqyu1ZFew0jKtSe+hCUuj3/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a724eUf3KrJ9h7LnBawF4Oo1vuXIx6rEmrKLLrA20kbkbZfAdUohTakLXnx30tHui
         AhS3CuFVBdJ35OffDH7hBColgPfxD4CgBCtDPHF7sEIGSnlLtkbsqIs2oHppxEDUrI
         sh2dgOG1a0K0LYeG66LMx7F6ZLBNKKalfO3kImbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5.9 387/391] vhost_vdpa: Return -EFAULT if copy_from_user() fails
Date:   Tue,  3 Nov 2020 21:37:18 +0100
Message-Id: <20201103203413.277357607@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 7922460e33c81f41e0d2421417228b32e6fdbe94 upstream.

The copy_to/from_user() functions return the number of bytes which we
weren't able to copy but the ioctl should return -EFAULT if they fail.

Fixes: a127c5bbb6a8 ("vhost-vdpa: fix backend feature ioctls")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20201023120853.GI282278@mwanda
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: stable@vger.kernel.org
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/vdpa.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -428,12 +428,11 @@ static long vhost_vdpa_unlocked_ioctl(st
 	void __user *argp = (void __user *)arg;
 	u64 __user *featurep = argp;
 	u64 features;
-	long r;
+	long r = 0;
 
 	if (cmd == VHOST_SET_BACKEND_FEATURES) {
-		r = copy_from_user(&features, featurep, sizeof(features));
-		if (r)
-			return r;
+		if (copy_from_user(&features, featurep, sizeof(features)))
+			return -EFAULT;
 		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
 			return -EOPNOTSUPP;
 		vhost_set_backend_features(&v->vdev, features);
@@ -476,7 +475,8 @@ static long vhost_vdpa_unlocked_ioctl(st
 		break;
 	case VHOST_GET_BACKEND_FEATURES:
 		features = VHOST_VDPA_BACKEND_FEATURES;
-		r = copy_to_user(featurep, &features, sizeof(features));
+		if (copy_to_user(featurep, &features, sizeof(features)))
+			r = -EFAULT;
 		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);


