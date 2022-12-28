Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C46657AD5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbiL1PPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbiL1PPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:15:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1672313F18
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:15:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7AAC61551
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAABBC433D2;
        Wed, 28 Dec 2022 15:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240521;
        bh=NwpmSBB8E6VbdEyBKNLEtjrA8uAaF0ZUtLvneo0GimE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pgq47zDeOOrGVmtqePUaTg609oGItDZzAHI4wD75NekLrXBFghXBhJk2R25cuBxMf
         mzd1FkUpmONvuzezvFNbxZNCcRjxlispP0BR1FvWDRKk8cA1hgqFafKdlEzorv08fT
         kZtHCw0AGiYsuUssITauZ/nwUB0VzXHzGRszla6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhao Gongyi <zhaogongyi@huawei.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0135/1146] selftests/efivarfs: Add checking of the test return value
Date:   Wed, 28 Dec 2022 15:27:54 +0100
Message-Id: <20221228144333.816207631@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Zhao Gongyi <zhaogongyi@huawei.com>

[ Upstream commit c93924267fe6f2b44af1849f714ae9cd8117a9cd ]

Add checking of the test return value, otherwise it will report success
forever for test_create_read().

Fixes: dff6d2ae56d0 ("selftests/efivarfs: clean up test files from test_create*()")
Signed-off-by: Zhao Gongyi <zhaogongyi@huawei.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/efivarfs/efivarfs.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/efivarfs/efivarfs.sh b/tools/testing/selftests/efivarfs/efivarfs.sh
index a90f394f9aa9..d374878cc0ba 100755
--- a/tools/testing/selftests/efivarfs/efivarfs.sh
+++ b/tools/testing/selftests/efivarfs/efivarfs.sh
@@ -87,6 +87,11 @@ test_create_read()
 {
 	local file=$efivarfs_mount/$FUNCNAME-$test_guid
 	./create-read $file
+	if [ $? -ne 0 ]; then
+		echo "create and read $file failed"
+		file_cleanup $file
+		exit 1
+	fi
 	file_cleanup $file
 }
 
-- 
2.35.1



