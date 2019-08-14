Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855968C5F3
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfHNCLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727427AbfHNCLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:11:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E947A20843;
        Wed, 14 Aug 2019 02:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748692;
        bh=cD+Zhfy+M0hjFszWVvt6SMupSaZ0cXfm6e1X3yY7n74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gfg+C7bDy2H4Ps8Ge97TCDcowEA7+e9kQ2Pqb69zvOlaQBVB6XBsb4X/eeWMCAksd
         OiQoZS8Pvps7P6f93SbvAj2xhgmM1OzbFTNZ3wv5CBm1ZcRwZN6cyXQQSOup/WR5ZX
         RMbamNwT2EHyqenm6lkqo/04lru1Aw4BC/dkaDwM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 023/123] ASoC: SOF: use __u32 instead of uint32_t in uapi headers
Date:   Tue, 13 Aug 2019 22:09:07 -0400
Message-Id: <20190814021047.14828-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

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

