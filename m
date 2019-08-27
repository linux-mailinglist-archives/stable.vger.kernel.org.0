Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3279B9E141
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731868AbfH0ICI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731450AbfH0ICH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:02:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7881206BA;
        Tue, 27 Aug 2019 08:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892926;
        bh=lSYLQUjB0VoP5M9CNwmV9PEN0Wvx2anBrrjB04AK79I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DT6huTMfXMZEZx/sdWQQYbSjp93eehwPlkE+77sxQT0g0mOLUWleeU7tRfquWR0UG
         3uDoTXyZv4b3kacGlcK9K+zI9tD2Y7FJM7JlPoF7MIeQCaQHcKHlJoaWDPjmEfLbfx
         d50lJA/bCgd05NJDktgQ+ctValp/7zYNw7BjCDMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 019/162] ASoC: SOF: use __u32 instead of uint32_t in uapi headers
Date:   Tue, 27 Aug 2019 09:49:07 +0200
Message-Id: <20190827072738.995626161@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 62ec3d13601bd626ca7a0edef6d45dbb753d94e8 ]

When CONFIG_UAPI_HEADER_TEST=y, exported headers are compile-tested to
make sure they can be included from user-space.

Currently, header.h and fw.h are excluded from the test coverage.
To make them join the compile-test, we need to fix the build errors
attached below.

For a case like this, we decided to use __u{8,16,32,64} variable types
in this discussion:

  https://lkml.org/lkml/2019/6/5/18

Build log:

  CC      usr/include/sound/sof/header.h.s
  CC      usr/include/sound/sof/fw.h.s
In file included from <command-line>:32:0:
./usr/include/sound/sof/header.h:19:2: error: unknown type name ‘uint32_t’
  uint32_t magic;  /**< 'S', 'O', 'F', '\0' */
  ^~~~~~~~
./usr/include/sound/sof/header.h:20:2: error: unknown type name ‘uint32_t’
  uint32_t type;  /**< component specific type */
  ^~~~~~~~
./usr/include/sound/sof/header.h:21:2: error: unknown type name ‘uint32_t’
  uint32_t size;  /**< size in bytes of data excl. this struct */
  ^~~~~~~~
./usr/include/sound/sof/header.h:22:2: error: unknown type name ‘uint32_t’
  uint32_t abi;  /**< SOF ABI version */
  ^~~~~~~~
./usr/include/sound/sof/header.h:23:2: error: unknown type name ‘uint32_t’
  uint32_t reserved[4]; /**< reserved for future use */
  ^~~~~~~~
./usr/include/sound/sof/header.h:24:2: error: unknown type name ‘uint32_t’
  uint32_t data[0]; /**< Component data - opaque to core */
  ^~~~~~~~
In file included from <command-line>:32:0:
./usr/include/sound/sof/fw.h:49:2: error: unknown type name ‘uint32_t’
  uint32_t size;  /* bytes minus this header */
  ^~~~~~~~
./usr/include/sound/sof/fw.h:50:2: error: unknown type name ‘uint32_t’
  uint32_t offset; /* offset from base */
  ^~~~~~~~
./usr/include/sound/sof/fw.h:64:2: error: unknown type name ‘uint32_t’
  uint32_t size;  /* bytes minus this header */
  ^~~~~~~~
./usr/include/sound/sof/fw.h:65:2: error: unknown type name ‘uint32_t’
  uint32_t num_blocks; /* number of blocks */
  ^~~~~~~~
./usr/include/sound/sof/fw.h:73:2: error: unknown type name ‘uint32_t’
  uint32_t file_size; /* size of file minus this header */
  ^~~~~~~~
./usr/include/sound/sof/fw.h:74:2: error: unknown type name ‘uint32_t’
  uint32_t num_modules; /* number of modules */
  ^~~~~~~~
./usr/include/sound/sof/fw.h:75:2: error: unknown type name ‘uint32_t’
  uint32_t abi;  /* version of header format */
  ^~~~~~~~

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Link: https://lore.kernel.org/r/20190721142308.30306-1-yamada.masahiro@socionext.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/sound/sof/fw.h     | 16 +++++++++-------
 include/uapi/sound/sof/header.h | 14 ++++++++------
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/uapi/sound/sof/fw.h b/include/uapi/sound/sof/fw.h
index 1afca973eb097..e9f697467a861 100644
--- a/include/uapi/sound/sof/fw.h
+++ b/include/uapi/sound/sof/fw.h
@@ -13,6 +13,8 @@
 #ifndef __INCLUDE_UAPI_SOF_FW_H__
 #define __INCLUDE_UAPI_SOF_FW_H__
 
+#include <linux/types.h>
+
 #define SND_SOF_FW_SIG_SIZE	4
 #define SND_SOF_FW_ABI		1
 #define SND_SOF_FW_SIG		"Reef"
@@ -46,8 +48,8 @@ enum snd_sof_fw_blk_type {
 
 struct snd_sof_blk_hdr {
 	enum snd_sof_fw_blk_type type;
-	uint32_t size;		/* bytes minus this header */
-	uint32_t offset;	/* offset from base */
+	__u32 size;		/* bytes minus this header */
+	__u32 offset;		/* offset from base */
 } __packed;
 
 /*
@@ -61,8 +63,8 @@ enum snd_sof_fw_mod_type {
 
 struct snd_sof_mod_hdr {
 	enum snd_sof_fw_mod_type type;
-	uint32_t size;		/* bytes minus this header */
-	uint32_t num_blocks;	/* number of blocks */
+	__u32 size;		/* bytes minus this header */
+	__u32 num_blocks;	/* number of blocks */
 } __packed;
 
 /*
@@ -70,9 +72,9 @@ struct snd_sof_mod_hdr {
  */
 struct snd_sof_fw_header {
 	unsigned char sig[SND_SOF_FW_SIG_SIZE]; /* "Reef" */
-	uint32_t file_size;	/* size of file minus this header */
-	uint32_t num_modules;	/* number of modules */
-	uint32_t abi;		/* version of header format */
+	__u32 file_size;	/* size of file minus this header */
+	__u32 num_modules;	/* number of modules */
+	__u32 abi;		/* version of header format */
 } __packed;
 
 #endif
diff --git a/include/uapi/sound/sof/header.h b/include/uapi/sound/sof/header.h
index 7868990b0d6f3..5f4518e7a9723 100644
--- a/include/uapi/sound/sof/header.h
+++ b/include/uapi/sound/sof/header.h
@@ -9,6 +9,8 @@
 #ifndef __INCLUDE_UAPI_SOUND_SOF_USER_HEADER_H__
 #define __INCLUDE_UAPI_SOUND_SOF_USER_HEADER_H__
 
+#include <linux/types.h>
+
 /*
  * Header for all non IPC ABI data.
  *
@@ -16,12 +18,12 @@
  * Used by any bespoke component data structures or binary blobs.
  */
 struct sof_abi_hdr {
-	uint32_t magic;		/**< 'S', 'O', 'F', '\0' */
-	uint32_t type;		/**< component specific type */
-	uint32_t size;		/**< size in bytes of data excl. this struct */
-	uint32_t abi;		/**< SOF ABI version */
-	uint32_t reserved[4];	/**< reserved for future use */
-	uint32_t data[0];	/**< Component data - opaque to core */
+	__u32 magic;		/**< 'S', 'O', 'F', '\0' */
+	__u32 type;		/**< component specific type */
+	__u32 size;		/**< size in bytes of data excl. this struct */
+	__u32 abi;		/**< SOF ABI version */
+	__u32 reserved[4];	/**< reserved for future use */
+	__u32 data[0];		/**< Component data - opaque to core */
 }  __packed;
 
 #endif
-- 
2.20.1



