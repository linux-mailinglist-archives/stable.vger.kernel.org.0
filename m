Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D69F7C87B
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 18:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfGaQW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 12:22:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44439 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaQW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 12:22:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so70341143wrf.11
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 09:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WVsfxgIzSLakGHlBY2fhRVYkJN2Btvl/Gg0nSKH/t5M=;
        b=VG8dnJW3bG/P6O1WNKkyk51A92rY0eVPY6vWubdUDEXs7fw9+YxxV5Pg3P0cclaQ1X
         KL4cV5SKARrebF62wfJjH1O06DCYammU8V4mZF6nZpaPZo4P3Z1mxiegzlFKhDyFifyl
         fWqRnTDG1w3r3ULoB0JxKoTldRePG18NhLr9BQ3Bjf/QGY7+Xamo7eMGnkoacnL+9kEd
         Mh5ORUn6/1VG4/xiBpL+qfNweo/u6o6xSkkpol0ePleLFw83AHGY4bH1aFbirEmkyes5
         GEoMa+Tq65OS+0S1ZlFI3SG9D3F8uEcJRJDq8fqOjJm1NU2P105DZNm7NgQGPpIYjlYB
         QmVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WVsfxgIzSLakGHlBY2fhRVYkJN2Btvl/Gg0nSKH/t5M=;
        b=ZimMxKK0eHhgihBvccycr+cpF5RoyZjivcHMgATIZV8QI2b/eX5h1zFur85MUpyreM
         i3uVhvKtcLOkqDcqc/oOzfyeaCECQSFFBXFp2ygLHx8qxyLzSafPnfYfVCT4B4KS31za
         cCK6S3jf/h4elpGYQSanFQQWyQZekE518tURf5iZA8qJeeRLgJnt8jllnnWtzsuVoeyt
         y/bD5IeM6xH3zAIchYtNF2JrzbS464380xNu22HcuOlguq/LVrmHODL8g1Qq7YuH80Gi
         vKD7gPI8ARHPHCsiLFoXjnjp60ej+doJVt5pa4RXN+rCOr5W9FvkRbV95g8KAMHgA1Us
         nbtA==
X-Gm-Message-State: APjAAAV9Hfd4vN4L98cgGMvqU24jRlM+NvkYWczddk0FKw5d/5hUdhJ+
        mqupwRWKWUrc8BsqdK7rXShjMKTVfgkGVQiJxhPVQzYfgEc2DLACQHjUtbuHISU09Jc+IRL6v6r
        aPTMFtSlZe1oSmFbNEXM240iUZEYbnhJfY8zYZ2FOfLKB+cYkbV0GMgLmPCo7zhcVes35t8DaC0
        21I5ZKJoJnBUcEbUUO4g==
X-Google-Smtp-Source: APXvYqxw+4E0G5247kV9zSm5owyu6ImT/piiXa0qtegO+0uxj7Q8BvdaWy/HA/t5wNcQ9q0GuKxCug==
X-Received: by 2002:adf:f206:: with SMTP id p6mr63981937wro.216.1564590144371;
        Wed, 31 Jul 2019 09:22:24 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n9sm114557717wrp.54.2019.07.31.09.22.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 09:22:23 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     0x7f454c46@gmail.com, Joerg Roedel <jroedel@suse.de>,
        Dmitry Safonov <dima@arista.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH-4.19-stable 2/2] iommu/iova: Fix compilation error with !CONFIG_IOMMU_IOVA
Date:   Wed, 31 Jul 2019 17:22:20 +0100
Message-Id: <20190731162220.24364-3-dima@arista.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190731162220.24364-1-dima@arista.com>
References: <20190731162220.24364-1-dima@arista.com>
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
Signed-off-by: Dmitry Safonov <dima@arista.com>
[v4.14 backport]
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/iova.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iova.h b/include/linux/iova.h
index 073dc27d2e5f..84fbe73d2ec0 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -237,7 +237,7 @@ static inline void init_iova_domain(struct iova_domain *iovad,
 {
 }
 
-bool has_iova_flush_queue(struct iova_domain *iovad)
+static inline bool has_iova_flush_queue(struct iova_domain *iovad)
 {
 	return false;
 }
-- 
2.22.0

