Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD2663E013
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiK3SxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiK3SxK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:53:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E866325C5B
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:53:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F65161D76
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CABC433C1;
        Wed, 30 Nov 2022 18:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834388;
        bh=HQnziATy9GXeouqLcZTi0GRYACLnIQvqj6pEI65EoMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YdZ3TFgpt+sIvuScJD4GEjDOEfQBZFIIAKiPlkjTGpxoGRkid2pSw9gjh4d+jH+T6
         wVAtQ9KUbsNSXZFCOM7yCYE20PsaKgpxxsl5N55mCiYuvXeubnOFQGqsmFc/opmv85
         lMA/T91c5nZreDSCcdlpATHwcmoa/46QgiTDFQg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matti Vaittinen <mazziesaccount@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 228/289] tools: iio: iio_generic_buffer: Fix read size
Date:   Wed, 30 Nov 2022 19:23:33 +0100
Message-Id: <20221130180549.283587335@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 7c919b619bcc68158921b1bd968f0e704549bbb6 ]

When noevents is true and small buffer is used the allocated memory for
holding the data may be smaller than the hard-coded 64 bytes. This can
cause the iio_generic_buffer to crash.

Following was recorded on beagle bone black with v6.0 kernel and the
digit fix patch:
https://lore.kernel.org/all/Y0f+tKCz+ZAIoroQ@dc75zzyyyyyyyyyyyyycy-3.rev.dnainternet.fi/
using valgrind;

==339== Using Valgrind-3.18.1 and LibVEX; rerun with -h for copyright info
==339== Command: /iio_generic_buffer -n kx022-accel -T0 -e -l 10 -a -w 2000000
==339== Parent PID: 307
==339==
==339== Syscall param read(buf) points to unaddressable byte(s)
==339==    at 0x496BFA4: read (read.c:26)
==339==    by 0x11699: main (iio_generic_buffer.c:724)
==339==  Address 0x4ab3518 is 0 bytes after a block of size 160 alloc'd
==339==    at 0x4864B70: malloc (vg_replace_malloc.c:381)
==339==    by 0x115BB: main (iio_generic_buffer.c:677)

Fix this by always using the same size for reading as was used for
data storage allocation.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://lore.kernel.org/r/Y0kMh0t5qUXJw3nQ@dc75zzyyyyyyyyyyyyycy-3.rev.dnainternet.fi
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/iio/iio_generic_buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/iio/iio_generic_buffer.c b/tools/iio/iio_generic_buffer.c
index 2491c54a5e4f..f8deae4e26a1 100644
--- a/tools/iio/iio_generic_buffer.c
+++ b/tools/iio/iio_generic_buffer.c
@@ -715,12 +715,12 @@ int main(int argc, char **argv)
 				continue;
 			}
 
-			toread = buf_len;
 		} else {
 			usleep(timedelay);
-			toread = 64;
 		}
 
+		toread = buf_len;
+
 		read_size = read(buf_fd, data, toread * scan_size);
 		if (read_size < 0) {
 			if (errno == EAGAIN) {
-- 
2.35.1



