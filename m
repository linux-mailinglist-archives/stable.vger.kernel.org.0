Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6637C1EFF27
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 19:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgFERiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 13:38:01 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40086 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgFERiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 13:38:01 -0400
Received: by mail-lj1-f193.google.com with SMTP id n23so12750545ljh.7;
        Fri, 05 Jun 2020 10:37:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v2RPwevKzEvUOUonTwAkZLpeDUxhkeZo2zDozwoA/PY=;
        b=edgK7UbIzb8CDwpqmcKIOqC+paR6c3+NWEbiJ8uCyeEWHtpkmsdQZokdU6tbBrx52i
         m8hBeXSDOCbMi4U97UCZwC2T3JotyBDA6PPJk5jbsccTiMeGWxFXyMboYevNZPOafAKq
         EbXD6SwneA0BNGtEx0SWrfpFgMzO7mK72tscaBXevScqLzoyrI8aFrunP76Tuus1venU
         WYXKtPQHaFdcCY0J0uSlAN0LLNzhbMVw+EyvLdJcD/eaHIdK3UkWCyj2rfUemL5Ioyc+
         T8kQn42zskGFxlQGzr0uuVK4s9hyrA5qg/YIX9yPOXCpwb15qA6z9Rs4pXFXwpN7wDoi
         kFDA==
X-Gm-Message-State: AOAM531Zkgs791X2Zc3NDe4RWxMpW+KH9w6TMorA85h9IK0rxbigtlnV
        2yXliENG2rpPyWoG6vXIZ+dNFEC0Fuw=
X-Google-Smtp-Source: ABdhPJzVqqz9tR4HxPTXi4jbiMDAs25LZATZhYzfPGtAEA8nsnjJ3hMQXptQB7JWYdCX4bmoCW4atw==
X-Received: by 2002:a2e:7c03:: with SMTP id x3mr1433951ljc.227.1591378678627;
        Fri, 05 Jun 2020 10:37:58 -0700 (PDT)
Received: from localhost.localdomain (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.googlemail.com with ESMTPSA id w1sm1049514ljo.80.2020.06.05.10.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 10:37:57 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Leo Li <sunpeng.li@amd.com>
Cc:     Denis Efremov <efremov@linux.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Krunoslav Kovac <Krunoslav.Kovac@amd.com>,
        amd-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] drm/amd/display: Use kvfree() to free coeff in build_regamma()
Date:   Fri,  5 Jun 2020 20:37:43 +0300
Message-Id: <20200605173744.68500-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use kvfree() instead of kfree() to free coeff in build_regamma()
because the memory is allocated with kvzalloc().

Fixes: e752058b8671 ("drm/amd/display: Optimize gamma calculations")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
index 9431b48aecb4..56bb1f9f77ce 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -843,7 +843,7 @@ static bool build_regamma(struct pwl_float_data_ex *rgb_regamma,
 	pow_buffer_ptr = -1; // reset back to no optimize
 	ret = true;
 release:
-	kfree(coeff);
+	kvfree(coeff);
 	return ret;
 }
 
-- 
2.26.2

