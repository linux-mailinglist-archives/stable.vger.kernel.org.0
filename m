Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439F7667412
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjALOCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbjALOCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:02:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B632CD
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:02:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 75494CE1E70
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF39C433F1;
        Thu, 12 Jan 2023 14:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532125;
        bh=NwpmSBB8E6VbdEyBKNLEtjrA8uAaF0ZUtLvneo0GimE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgr69cU6kE+6AdSvipEKMtSTgOC3HqfzPgOT5GfdamfgNzhdb6wtI3ewM3t7xa3tb
         ziz9WWaYKVDaRoPqLfJEQSn3tBtkKiVgTiOTwJcteLjn0y1GerhpN8/6+OwJd5OU2v
         Au/Qr3phPg2gpJTHBC+CAvxIqe5n4TZrIoGzsJLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhao Gongyi <zhaogongyi@huawei.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/783] selftests/efivarfs: Add checking of the test return value
Date:   Thu, 12 Jan 2023 14:46:16 +0100
Message-Id: <20230112135526.931516895@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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



