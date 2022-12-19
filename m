Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0C5651322
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbiLST1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbiLST13 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:27:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18FE25DA
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:27:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FD99B80F4B
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DEAC433F0;
        Mon, 19 Dec 2022 19:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671478035;
        bh=HvNKuWYFW8umeX/fI6aXrzjdk4JcPKrYu3UMnlPw/N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ay6AkpVMmwykJOfVIrsMdsOtQY45ur42zSPBViAHal+Udp7nWbLmdsv0CztfWRB8Q
         M5gF4h/W4opj5u3A5TBXv3ewF3xwbu1TvWDrua0GyNoj+Xw85HoqHkIU75XAH8p93s
         YDOwK3B9ct0bleK+D+64B8TEso2Qo0VWN6BkSs3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/17] selftests: net: Use "grep -E" instead of "egrep"
Date:   Mon, 19 Dec 2022 20:25:02 +0100
Message-Id: <20221219182941.227748263@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
References: <20221219182940.739981110@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 6a30d3e3491dc562384e9f15b201a8a25b57439f ]

The latest version of grep claims the egrep is now obsolete so the build
now contains warnings that look like:
	egrep: warning: egrep is obsolescent; using grep -E
fix this using "grep -E" instead.

  sed -i "s/egrep/grep -E/g" `grep egrep -rwl tools/testing/selftests/net`

Here are the steps to install the latest grep:

  wget http://ftp.gnu.org/gnu/grep/grep-3.8.tar.gz
  tar xf grep-3.8.tar.gz
  cd grep-3.8 && ./configure && make
  sudo make install
  export PATH=/usr/local/bin:$PATH

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/r/1669864248-829-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/toeplitz.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/toeplitz.sh b/tools/testing/selftests/net/toeplitz.sh
index 0a49907cd4fe..da5bfd834eff 100755
--- a/tools/testing/selftests/net/toeplitz.sh
+++ b/tools/testing/selftests/net/toeplitz.sh
@@ -32,7 +32,7 @@ DEV="eth0"
 # This is determined by reading the RSS indirection table using ethtool.
 get_rss_cfg_num_rxqs() {
 	echo $(ethtool -x "${DEV}" |
-		egrep [[:space:]]+[0-9]+:[[:space:]]+ |
+		grep -E [[:space:]]+[0-9]+:[[:space:]]+ |
 		cut -d: -f2- |
 		awk '{$1=$1};1' |
 		tr ' ' '\n' |
-- 
2.35.1



