Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B4D60499B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 16:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiJSOqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 10:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiJSOqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 10:46:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0260DF5F;
        Wed, 19 Oct 2022 07:32:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE6BF6177D;
        Wed, 19 Oct 2022 09:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA3EC433D7;
        Wed, 19 Oct 2022 09:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170364;
        bh=Oez0xSkPvwxIgWUhwxsQd8h6OI5hQd7QDtdeIIXp/vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9UHvTasj6dlWCzd90IDPgDcANHzSWjtdkCDTRWS/DolJIYUt/J8VPSxtA09EgxZh
         elOJJGZnP6bIHBLMV44D7AmG0xBMCayoZZjE/+RCtDaQfJaBQ4EuGdtY4jAAQL4X17
         oIdqzIeEOHL5Tm7IYoreYiQnv+EA793zaeK2YdtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        kernel test robot <lkp@intel.com>,
        Jacky Li <jackyli@google.com>,
        David Rientjes <rientjes@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 627/862] crypto: ccp - Fail the PSP initialization when writing psp data file failed
Date:   Wed, 19 Oct 2022 10:31:54 +0200
Message-Id: <20221019083317.625376706@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacky Li <jackyli@google.com>

[ Upstream commit efb4b01c1c993d245e6608076684ff2162cf9dc6 ]

Currently the OS continues the PSP initialization when there is a write
failure to the init_ex_file. Therefore, the userspace would be told that
SEV is properly INIT'd even though the psp data file is not updated.
This is problematic because later when asked for the SEV data, the OS
won't be able to provide it.

Fixes: 3d725965f836 ("crypto: ccp - Add SEV_INIT_EX support")
Reported-by: Peter Gonda <pgonda@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jacky Li <jackyli@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9f588c9728f8..6c49e6d06114 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -231,7 +231,7 @@ static int sev_read_init_ex_file(void)
 	return 0;
 }
 
-static void sev_write_init_ex_file(void)
+static int sev_write_init_ex_file(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct file *fp;
@@ -241,14 +241,16 @@ static void sev_write_init_ex_file(void)
 	lockdep_assert_held(&sev_cmd_mutex);
 
 	if (!sev_init_ex_buffer)
-		return;
+		return 0;
 
 	fp = open_file_as_root(init_ex_path, O_CREAT | O_WRONLY, 0600);
 	if (IS_ERR(fp)) {
+		int ret = PTR_ERR(fp);
+
 		dev_err(sev->dev,
-			"SEV: could not open file for write, error %ld\n",
-			PTR_ERR(fp));
-		return;
+			"SEV: could not open file for write, error %d\n",
+			ret);
+		return ret;
 	}
 
 	nwrite = kernel_write(fp, sev_init_ex_buffer, NV_LENGTH, &offset);
@@ -259,18 +261,20 @@ static void sev_write_init_ex_file(void)
 		dev_err(sev->dev,
 			"SEV: failed to write %u bytes to non volatile memory area, ret %ld\n",
 			NV_LENGTH, nwrite);
-		return;
+		return -EIO;
 	}
 
 	dev_dbg(sev->dev, "SEV: write successful to NV file\n");
+
+	return 0;
 }
 
-static void sev_write_init_ex_file_if_required(int cmd_id)
+static int sev_write_init_ex_file_if_required(int cmd_id)
 {
 	lockdep_assert_held(&sev_cmd_mutex);
 
 	if (!sev_init_ex_buffer)
-		return;
+		return 0;
 
 	/*
 	 * Only a few platform commands modify the SPI/NV area, but none of the
@@ -285,10 +289,10 @@ static void sev_write_init_ex_file_if_required(int cmd_id)
 	case SEV_CMD_PEK_GEN:
 		break;
 	default:
-		return;
+		return 0;
 	}
 
-	sev_write_init_ex_file();
+	return sev_write_init_ex_file();
 }
 
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
@@ -361,7 +365,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 			cmd, reg & PSP_CMDRESP_ERR_MASK);
 		ret = -EIO;
 	} else {
-		sev_write_init_ex_file_if_required(cmd);
+		ret = sev_write_init_ex_file_if_required(cmd);
 	}
 
 	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
-- 
2.35.1



