Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F046420F0B
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbhJDNac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237507AbhJDN2d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:28:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3007361D7C;
        Mon,  4 Oct 2021 13:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353171;
        bh=/F9PQqw3XsZUH/IFwFAxTh1OULuuS3UjvwBwc2taDNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fI/16Urs7dadAftqvUKThUiKNUDlG5FV6bo8b46ymIfQbr8srBOh85V+rc08Mrk0y
         s1+mHiqG9/z/1imjMHAdBV4cm5F+84idyP5GKnWHCUfGehmniOE+XVaVzXGgYu62zr
         8foLFv4i+1jqLEphnX+SERZ37E8NUJebbuh6WlWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 003/172] media: s5p-jpeg: rename JPEG marker constants to prevent build warnings
Date:   Mon,  4 Oct 2021 14:50:53 +0200
Message-Id: <20211004125045.060219114@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 3ad02c27d89d72b3b49ac51899144b7d0942f05f ]

The use of a macro named 'RST' conflicts with one of the same name
in arch/mips/include/asm/mach-rc32434/rb.h. This causes build
warnings on some MIPS builds.

Change the names of the JPEG marker constants to be in their own
namespace to fix these build warnings and to prevent other similar
problems in the future.

Fixes these build warnings:

In file included from ../drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c:14:
../drivers/media/platform/s5p-jpeg/jpeg-core.h:43: warning: "RST" redefined
   43 | #define RST                             0xd0
      |
../arch/mips/include/asm/mach-rc32434/rb.h:13: note: this is the location of the previous definition
   13 | #define RST             (1 << 15)

In file included from ../drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c:13:
../drivers/media/platform/s5p-jpeg/jpeg-core.h:43: warning: "RST" redefined
   43 | #define RST                             0xd0
../arch/mips/include/asm/mach-rc32434/rb.h:13: note: this is the location of the previous definition
   13 | #define RST             (1 << 15)

In file included from ../drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c:12:
../drivers/media/platform/s5p-jpeg/jpeg-core.h:43: warning: "RST" redefined
   43 | #define RST                             0xd0
../arch/mips/include/asm/mach-rc32434/rb.h:13: note: this is the location of the previous definition
   13 | #define RST             (1 << 15)

In file included from ../drivers/media/platform/s5p-jpeg/jpeg-core.c:31:
../drivers/media/platform/s5p-jpeg/jpeg-core.h:43: warning: "RST" redefined
   43 | #define RST                             0xd0
../arch/mips/include/asm/mach-rc32434/rb.h:13: note: this is the location of the previous definition
   13 | #define RST             (1 << 15)

Also update the kernel-doc so that the word "marker" is not
repeated.

Link: https://lore.kernel.org/linux-media/20210907044022.30602-1-rdunlap@infradead.org
Fixes: bb677f3ac434 ("[media] Exynos4 JPEG codec v4l2 driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 18 ++++++-------
 drivers/media/platform/s5p-jpeg/jpeg-core.h | 28 ++++++++++-----------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index d402e456f27d..7d0ab19c38bb 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1140,8 +1140,8 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 			continue;
 		length = 0;
 		switch (c) {
-		/* SOF0: baseline JPEG */
-		case SOF0:
+		/* JPEG_MARKER_SOF0: baseline JPEG */
+		case JPEG_MARKER_SOF0:
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
@@ -1172,7 +1172,7 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 			notfound = 0;
 			break;
 
-		case DQT:
+		case JPEG_MARKER_DQT:
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
@@ -1185,7 +1185,7 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 			skip(&jpeg_buffer, length);
 			break;
 
-		case DHT:
+		case JPEG_MARKER_DHT:
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
@@ -1198,15 +1198,15 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 			skip(&jpeg_buffer, length);
 			break;
 
-		case SOS:
+		case JPEG_MARKER_SOS:
 			sos = jpeg_buffer.curr - 2; /* 0xffda */
 			break;
 
 		/* skip payload-less markers */
-		case RST ... RST + 7:
-		case SOI:
-		case EOI:
-		case TEM:
+		case JPEG_MARKER_RST ... JPEG_MARKER_RST + 7:
+		case JPEG_MARKER_SOI:
+		case JPEG_MARKER_EOI:
+		case JPEG_MARKER_TEM:
 			break;
 
 		/* skip uninteresting payload markers */
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index a77d93c098ce..8473a019bb5f 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -37,15 +37,15 @@
 #define EXYNOS3250_IRQ_TIMEOUT		0x10000000
 
 /* a selection of JPEG markers */
-#define TEM				0x01
-#define SOF0				0xc0
-#define DHT				0xc4
-#define RST				0xd0
-#define SOI				0xd8
-#define EOI				0xd9
-#define	SOS				0xda
-#define DQT				0xdb
-#define DHP				0xde
+#define JPEG_MARKER_TEM				0x01
+#define JPEG_MARKER_SOF0				0xc0
+#define JPEG_MARKER_DHT				0xc4
+#define JPEG_MARKER_RST				0xd0
+#define JPEG_MARKER_SOI				0xd8
+#define JPEG_MARKER_EOI				0xd9
+#define	JPEG_MARKER_SOS				0xda
+#define JPEG_MARKER_DQT				0xdb
+#define JPEG_MARKER_DHP				0xde
 
 /* Flags that indicate a format can be used for capture/output */
 #define SJPEG_FMT_FLAG_ENC_CAPTURE	(1 << 0)
@@ -187,11 +187,11 @@ struct s5p_jpeg_marker {
  * @fmt:	driver-specific format of this queue
  * @w:		image width
  * @h:		image height
- * @sos:	SOS marker's position relative to the buffer beginning
- * @dht:	DHT markers' positions relative to the buffer beginning
- * @dqt:	DQT markers' positions relative to the buffer beginning
- * @sof:	SOF0 marker's position relative to the buffer beginning
- * @sof_len:	SOF0 marker's payload length (without length field itself)
+ * @sos:	JPEG_MARKER_SOS's position relative to the buffer beginning
+ * @dht:	JPEG_MARKER_DHT' positions relative to the buffer beginning
+ * @dqt:	JPEG_MARKER_DQT' positions relative to the buffer beginning
+ * @sof:	JPEG_MARKER_SOF0's position relative to the buffer beginning
+ * @sof_len:	JPEG_MARKER_SOF0's payload length (without length field itself)
  * @size:	image buffer size in bytes
  */
 struct s5p_jpeg_q_data {
-- 
2.33.0



