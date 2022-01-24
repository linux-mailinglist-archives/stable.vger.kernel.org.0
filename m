Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCC64986CA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 18:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244582AbiAXR3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 12:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244573AbiAXR3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 12:29:55 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7FCC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 09:29:55 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d7so16218899plr.12
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 09:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DgXlun9btBBSUmiix9Clp2ASfQHzqDBGv3T/rV7kA6I=;
        b=JkumDcRfVORGI60Me6r9fp0pjugDK3oZgO25wFWH/YEXPurm8Fe6n5j18sH9Sl/ie1
         vWyrA8CYQftFH7g3nJopJLp8uMliN4dKpSolzj08mg3/1J96ACuGwC7iHZSOoUOtcIGP
         jC3/4buu9+q+Mbd6+aJDI07lPkJB0Mcc/dlWo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DgXlun9btBBSUmiix9Clp2ASfQHzqDBGv3T/rV7kA6I=;
        b=XSuRfTijAWQE6CqXN4Kx23uIGm1zNYLJzRnTDcbUZthWhD0o6TmYnP3Bs5YVXjTuix
         cWrbZ/EOcloORPO9yap+oSE0p677UeUTX1Na1YYpnRHzcHb017zO6cwbYZwoC4xXc14f
         0iYL/DiGvZAtTbRQPCRFXMnrCVmP5fOxl6FnRpJ/nH3Adg6AsDu4rhYxjtxBjur3tx6T
         G3/E1YgCxhGb0mbOo7HijtgDd27cgP4k9yo3UiZj9b9ziME5TSD4hsQp+mxdtCI8ghyJ
         FJRvnYRpIWEpfr8kt10FWcvz6ODIsumNnEi3RNyNIABtZ8cwZHesGn6nP46p4Wk4UY2h
         BLwQ==
X-Gm-Message-State: AOAM531Qlw8Mu+qPa4St3cKvqfutdxn60Hnr2j6mbXSXo1pAr74NQB/e
        NPHiPdAJbVb+tjKzaKFOtTK3mQ==
X-Google-Smtp-Source: ABdhPJw1hNa+nUhKIFuxRF9/rNyBIxX7tebJ+rW86YIOIZa0zebC4dL/dbia5M4QCW+YxCH+QwCb/w==
X-Received: by 2002:a17:902:a408:b0:14a:d2ea:5a2b with SMTP id p8-20020a170902a40800b0014ad2ea5a2bmr14988773plq.115.1643045394651;
        Mon, 24 Jan 2022 09:29:54 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m17sm17337679pfk.62.2022.01.24.09.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 09:29:54 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, stable@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH RESEND] media: omap3isp: Use struct_group() for memcpy() region
Date:   Mon, 24 Jan 2022 09:29:52 -0800
Message-Id: <20220124172952.2411764-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4705; h=from:subject; bh=oa/cUXWpSfkCxLLoNQotX2hWIvBBQ2nEDbLhRiHg/WI=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBh7uIQfzKSQEGnylISh8uJvLEpO6KrYu+j+JmXGK0U KMX/pYqJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYe7iEAAKCRCJcvTf3G3AJhJIEA CKE5Tih0LP/9wjDJ1lHDwtZWeWaNtsCb2YeF/Fauxgfc/i5vsuphJ3AIjY5r8dlJGf5r9/nUL91itR YWf+B0JLXk0y4tNbpupUpiZ+3wZ2kYCHkGaOB7SQWBrpLJGbhD2C+Q7K3LoijhJsxqQpP2gj6wwFc2 b9dqBsSXFalfJtl35JE88x7cizoyId34lN6AemDI5l58Hd2BTWInhTLhlVTbyge3hA3Rp6QWlmaoZi NBOfXwjIVHH6H4XOSg80i+SPrtQwLsRk8v/3GeCWVzeVlqN75VVzLIyp/mPWZ3srogmdlCN9PpN0Sz klWIwEu4YAzhleo4W4Rwwu7Y6W6cayH2zel6xaH+iRT0W90i4Pybh2ipwJEF3cIJodmoZVPilp+7Ya 4MqRgqtNJ2qfi8BZx7i+oXx468EnElS3oAE7gETDt2q90WUjAU15tQxV4Zz2FRsX7NFwP2Pe0y9UD2 AiWEFWDpbe3RImfxJvQussi/IMejMVb6AEFSpXS+0uJnxiXoEj+HrT2A9HqlU1FzR3ape+r1sTNA6E UcpA3EfGy7kvdUpDHAtRFSpsqw21lYoo7Ry3fwIZTkcwhFlbNobsMC//KW3OvRG9aEYH7Il0yUrUqI bMxQZ5MBsUeCuAJt2KsMZDuFntvD1ibeSXNFj3nbkLOuCpIcpESC7cAklhoQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields. Wrap the target region
in struct_group(). This additionally fixes a theoretical misalignment
of the copy (since the size of "buf" changes between 64-bit and 32-bit,
but this is likely never built for 64-bit).

FWIW, I think this code is totally broken on 64-bit (which appears to
not be a "real" build configuration): it would either always fail (with
an uninitialized data->buf_size) or would cause corruption in userspace
due to the copy_to_user() in the call path against an uninitialized
data->buf value:

omap3isp_stat_request_statistics_time32(...)
    struct omap3isp_stat_data data64;
    ...
    omap3isp_stat_request_statistics(stat, &data64);

int omap3isp_stat_request_statistics(struct ispstat *stat,
                                     struct omap3isp_stat_data *data)
    ...
    buf = isp_stat_buf_get(stat, data);

static struct ispstat_buffer *isp_stat_buf_get(struct ispstat *stat,
                                               struct omap3isp_stat_data *data)
...
    if (buf->buf_size > data->buf_size) {
            ...
            return ERR_PTR(-EINVAL);
    }
    ...
    rval = copy_to_user(data->buf,
                        buf->virt_addr,
                        buf->buf_size);

Regardless, additionally initialize data64 to be zero-filled to avoid
undefined behavior.

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Fixes: 378e3f81cb56 ("media: omap3isp: support 64-bit version of omap3isp_stat_data")
Cc: stable@vger.kernel.org
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/lkml/20211215220505.GB21862@embeddedor
Signed-off-by: Kees Cook <keescook@chromium.org>
---
I will carry this in my tree unless someone else wants to pick it up. It's
one of the last remaining clean-ups needed for the next step in memcpy()
hardening.
---
 drivers/media/platform/omap3isp/ispstat.c |  5 +++--
 include/uapi/linux/omap3isp.h             | 21 +++++++++++++--------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 5b9b57f4d9bf..68cf68dbcace 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -512,7 +512,7 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
 int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
 					struct omap3isp_stat_data_time32 *data)
 {
-	struct omap3isp_stat_data data64;
+	struct omap3isp_stat_data data64 = { };
 	int ret;
 
 	ret = omap3isp_stat_request_statistics(stat, &data64);
@@ -521,7 +521,8 @@ int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
 
 	data->ts.tv_sec = data64.ts.tv_sec;
 	data->ts.tv_usec = data64.ts.tv_usec;
-	memcpy(&data->buf, &data64.buf, sizeof(*data) - sizeof(data->ts));
+	data->buf = (uintptr_t)data64.buf;
+	memcpy(&data->frame, &data64.frame, sizeof(data->frame));
 
 	return 0;
 }
diff --git a/include/uapi/linux/omap3isp.h b/include/uapi/linux/omap3isp.h
index 87b55755f4ff..d9db7ad43890 100644
--- a/include/uapi/linux/omap3isp.h
+++ b/include/uapi/linux/omap3isp.h
@@ -162,6 +162,7 @@ struct omap3isp_h3a_aewb_config {
  * struct omap3isp_stat_data - Statistic data sent to or received from user
  * @ts: Timestamp of returned framestats.
  * @buf: Pointer to pass to user.
+ * @buf_size: Size of buffer.
  * @frame_number: Frame number of requested stats.
  * @cur_frame: Current frame number being processed.
  * @config_counter: Number of the configuration associated with the data.
@@ -176,10 +177,12 @@ struct omap3isp_stat_data {
 	struct timeval ts;
 #endif
 	void __user *buf;
-	__u32 buf_size;
-	__u16 frame_number;
-	__u16 cur_frame;
-	__u16 config_counter;
+	__struct_group(/* no tag */, frame, /* no attrs */,
+		__u32 buf_size;
+		__u16 frame_number;
+		__u16 cur_frame;
+		__u16 config_counter;
+	);
 };
 
 #ifdef __KERNEL__
@@ -189,10 +192,12 @@ struct omap3isp_stat_data_time32 {
 		__s32	tv_usec;
 	} ts;
 	__u32 buf;
-	__u32 buf_size;
-	__u16 frame_number;
-	__u16 cur_frame;
-	__u16 config_counter;
+	__struct_group(/* no tag */, frame, /* no attrs */,
+		__u32 buf_size;
+		__u16 frame_number;
+		__u16 cur_frame;
+		__u16 config_counter;
+	);
 };
 #endif
 
-- 
2.30.2

