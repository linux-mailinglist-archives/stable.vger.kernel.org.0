Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F94DB2074
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390962AbfIMNWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390973AbfIMNWL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:22:11 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73AEA214AE;
        Fri, 13 Sep 2019 13:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380930;
        bh=/nvSdDdkuOkxtV8ySXQRCik+0vs/UJWaIb4atO2eONE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pt4JnI8ySVxr4+V24ZrvjPAm1pXi5STlm4uP6I9xXLodhpZyD5rxzwfgwpTef91rU
         oyMhvhor/79XCUn4SJQbOqzKjOzkPXsOoeWHN01b9SmKWGUkRFZ1HIk0RGx7AWUeb6
         J0kIP89ukcBaEOWRGb9dtSiEvjph9i5fx972dURI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 29/37] virtio/s390: fix race on airq_areas[]
Date:   Fri, 13 Sep 2019 14:07:34 +0100
Message-Id: <20190913130521.250696506@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130510.727515099@linuxfoundation.org>
References: <20190913130510.727515099@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4f419eb14272e0698e8c55bb5f3f266cc2a21c81 ]

The access to airq_areas was racy ever since the adapter interrupts got
introduced to virtio-ccw, but since commit 39c7dcb15892 ("virtio/s390:
make airq summary indicators DMA") this became an issue in practice as
well. Namely before that commit the airq_info that got overwritten was
still functional. After that commit however the two infos share a
summary_indicator, which aggravates the situation. Which means
auto-online mechanism occasionally hangs the boot with virtio_blk.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 96b14536d935 ("virtio-ccw: virtio-ccw adapter interrupt support.")
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/virtio/virtio_ccw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 6a30768813219..8d47ad61bac3d 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -132,6 +132,7 @@ struct airq_info {
 	struct airq_iv *aiv;
 };
 static struct airq_info *airq_areas[MAX_AIRQ_AREAS];
+static DEFINE_MUTEX(airq_areas_lock);
 
 #define CCW_CMD_SET_VQ 0x13
 #define CCW_CMD_VDEV_RESET 0x33
@@ -244,9 +245,11 @@ static unsigned long get_airq_indicator(struct virtqueue *vqs[], int nvqs,
 	unsigned long bit, flags;
 
 	for (i = 0; i < MAX_AIRQ_AREAS && !indicator_addr; i++) {
+		mutex_lock(&airq_areas_lock);
 		if (!airq_areas[i])
 			airq_areas[i] = new_airq_info();
 		info = airq_areas[i];
+		mutex_unlock(&airq_areas_lock);
 		if (!info)
 			return 0;
 		write_lock_irqsave(&info->lock, flags);
-- 
2.20.1



