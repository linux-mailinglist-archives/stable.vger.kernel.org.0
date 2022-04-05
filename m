Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B813B4F33FB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238230AbiDEJEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243770AbiDEIvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:51:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20678BD7D5;
        Tue,  5 Apr 2022 01:39:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ADD961509;
        Tue,  5 Apr 2022 08:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A95AC385A0;
        Tue,  5 Apr 2022 08:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147930;
        bh=yYKeKn+Ed/LkVtvm0fukD9Z7cSasuVdQaF41PeMuKEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJ2lVbg/i90ohOb+im20fML0x6mBTZr5jpMgWkyaAnC3/UCLJLQyqhYJNS7qz7gem
         YHPvpgZIAPWE2uZF2a9vsMrdIOVe0EKUMbEu9Nt9Fp0KJT8tzfS67F8DMItAN2D20X
         ZiAOfZq/n+S+DfBxxgmUu31SYcW2wzFBI5VPlaRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.16 0173/1017] media: omap3isp: Use struct_group() for memcpy() region
Date:   Tue,  5 Apr 2022 09:18:06 +0200
Message-Id: <20220405070359.364257842@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit d4568fc8525897e683983806f813be1ae9eedaed upstream.

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

Link: https://lore.kernel.org/lkml/20211215220505.GB21862@embeddedor

Cc: Arnd Bergmann <arnd@arndb.de>
Fixes: 378e3f81cb56 ("media: omap3isp: support 64-bit version of omap3isp_stat_data")
Cc: stable@vger.kernel.org
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/omap3isp/ispstat.c |    5 +++--
 include/uapi/linux/omap3isp.h             |   21 +++++++++++++--------
 2 files changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -512,7 +512,7 @@ int omap3isp_stat_request_statistics(str
 int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
 					struct omap3isp_stat_data_time32 *data)
 {
-	struct omap3isp_stat_data data64;
+	struct omap3isp_stat_data data64 = { };
 	int ret;
 
 	ret = omap3isp_stat_request_statistics(stat, &data64);
@@ -521,7 +521,8 @@ int omap3isp_stat_request_statistics_tim
 
 	data->ts.tv_sec = data64.ts.tv_sec;
 	data->ts.tv_usec = data64.ts.tv_usec;
-	memcpy(&data->buf, &data64.buf, sizeof(*data) - sizeof(data->ts));
+	data->buf = (uintptr_t)data64.buf;
+	memcpy(&data->frame, &data64.frame, sizeof(data->frame));
 
 	return 0;
 }
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
 


