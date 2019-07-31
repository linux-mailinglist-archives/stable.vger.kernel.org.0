Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464D97C887
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 18:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725209AbfGaQX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 12:23:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35630 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbfGaQX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 12:23:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id y4so70376586wrm.2
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 09:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lwaNVMb7bQOKA1btcB4gkdh7MKab2pxu5av4NZwDRho=;
        b=OY/+JdExgVF6kKC1WMQ3POzxJ1R9XUzpy/N0YX5b70CDvodXtd4Cs8LthrtS6s6K2e
         ON43vyJNRYT1tUKe/7vNOmu0r3G/byVFyYOEcog2DasPuBwxl3rl3eKq+0eqWYIeSWLq
         7BG6mMmydcnADrN6VXpVE9aCDqZqPlkI4aMKaO5fcmzjRz1izzMbJDJi3t9fosAQKeNu
         sTmq17uYIV25epadPIzvoc/vmdE2jDLaZcDa0LP8xoi/Do4vG0RCmmiHZW+Kf7cOsha0
         9myYCgE/BJk7N5TCMup4ISllYQaHU67HLX/iTWUJeo4W9AwLDWLn5yCUJacIInKr7gf8
         s5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lwaNVMb7bQOKA1btcB4gkdh7MKab2pxu5av4NZwDRho=;
        b=b0DgtK6rJj1PPZ8OiApZpjgjTTMgxL9oJMcanKZ0hYJP92kwalILcvlONHC76+5Ahl
         VNe4LD/z6n1vLOV8c8pD9UJiuMqNpjoXoLIPOvf8WciGItujwKYwCb59CUjXND8ZHr/J
         f8T2TbG27qRJouKlnHTv4aLVV8ZicCrf0QHWyou5Dy6O05PctX1QgYGvcJzbbV9he+mu
         IPjTcYyiS2GnmRjaocSciK0ySMwBMIiBtNler/y2MOJSxJJW/VfaQKX4KVgZKdX4odkw
         5sDcnIvmXioNqES9ryWQQgVDvYUOGdaid7WyfozUkz1fUyz93VdB7Ww3cGMx2j5biJ9G
         Xazg==
X-Gm-Message-State: APjAAAUgFucGiyehmns5IpFsRn4rkJFfQdejiXvC5ksbQ4f211eL27In
        dTvBeZo6tT/9znW3kPOiJEKAuD2sHWUbEvxg/Lkz2ZezGOWAJMZ5IGGunW7PD4hgToTUEuiG20k
        bfY7fZnQcW1LJEHW5F2pxxzIDjihGHG/oHYuRAwsCbv3ptRuDD5dUyXCw2TOpwqvmRQuQ4bMplr
        VaY4Uv5HCaqjTv/BRKvg==
X-Google-Smtp-Source: APXvYqwfB6dpsWlwEVhi4/aRnUaCsydKCLE3hhBx2o58ln9wSsaMYw+Mjw8ZHPqYEEtoYK51v7ADZA==
X-Received: by 2002:adf:ab51:: with SMTP id r17mr109213301wrc.95.1564590206025;
        Wed, 31 Jul 2019 09:23:26 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id c3sm75530382wrx.19.2019.07.31.09.23.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 09:23:25 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     0x7f454c46@gmail.com, Joerg Roedel <jroedel@suse.de>,
        Dmitry Safonov <dima@arista.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH-4.14-stable 2/2] iommu/iova: Fix compilation error with !CONFIG_IOMMU_IOVA
Date:   Wed, 31 Jul 2019 17:23:21 +0100
Message-Id: <20190731162321.24607-3-dima@arista.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190731162321.24607-1-dima@arista.com>
References: <20190731162321.24607-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CLOUD-SEC-AV-Info: arista,google_mail,monitor
X-CLOUD-SEC-AV-Sent: true
X-Gm-Spam: 0
X-Gm-Phishy: 0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit 201c1db90cd643282185a00770f12f95da330eca ]

The stub function for !CONFIG_IOMMU_IOVA needs to be
'static inline'.

Fixes: effa467870c76 ('iommu/vt-d: Don't queue_iova() if there is no flush queue')
Signed-off-by: Joerg Roedel <jroedel@suse.de>
[v4.14 backport]
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/iova.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iova.h b/include/linux/iova.h
index 0ecf069b1659..7d23bbb887f2 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -235,7 +235,7 @@ static inline void init_iova_domain(struct iova_domain *iovad,
 {
 }
 
-bool has_iova_flush_queue(struct iova_domain *iovad)
+static inline bool has_iova_flush_queue(struct iova_domain *iovad)
 {
 	return false;
 }
-- 
2.22.0

