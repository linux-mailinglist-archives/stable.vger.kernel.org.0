Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F042F9F43
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390980AbhARLua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:50:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390754AbhARLql (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B90122D49;
        Mon, 18 Jan 2021 11:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970382;
        bh=jqKKOIQu7nkASQX8/yU0m63PngIdCOEBu10esmCG7wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTfOIxA6Y2GV8qp9r0Rhq1F9LqtJUN0TvtbXRuGmSOpJXCXEb/WgorouhSFlS63Bz
         4jKEiNl9zdTjNa1riDv4XVE19k5pemWwASzj32w53iJxJ6gL2eqnpa/Vf/hHv/cVdS
         uH2tJO7Udc/nUEmU7E1qc2n9MuOSq4pVtJRsQdyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 139/152] dm zoned: select CONFIG_CRC32
Date:   Mon, 18 Jan 2021 12:35:14 +0100
Message-Id: <20210118113359.384198731@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit b690bd546b227c32b860dae985a18bed8aa946fe upstream.

Without crc32 support, this driver fails to link:

arm-linux-gnueabi-ld: drivers/md/dm-zoned-metadata.o: in function `dmz_write_sb':
dm-zoned-metadata.c:(.text+0xe98): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/md/dm-zoned-metadata.o: in function `dmz_check_sb':
dm-zoned-metadata.c:(.text+0x7978): undefined reference to `crc32_le'

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -602,6 +602,7 @@ config DM_ZONED
 	tristate "Drive-managed zoned block device target support"
 	depends on BLK_DEV_DM
 	depends on BLK_DEV_ZONED
+	select CRC32
 	help
 	  This device-mapper target takes a host-managed or host-aware zoned
 	  block device and exposes most of its capacity as a regular block


