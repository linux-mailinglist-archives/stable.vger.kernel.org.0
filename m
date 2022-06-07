Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628965417A1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378966AbiFGVEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377539AbiFGVCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:02:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150AD13392E;
        Tue,  7 Jun 2022 11:48:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 580F9B82018;
        Tue,  7 Jun 2022 18:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1619C385A2;
        Tue,  7 Jun 2022 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627702;
        bh=eoTntXkJva1hHSA1bjTzO8FjSkV4RFJ+pjuoRT5FL7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2RINI0h0VbUpDCnV9JiNzDin/N0XwDPMNpPHUlM0wwUQoFbJneafBBPbjGYVbLBD
         G8tzaqNlcMhhLeoo9jq0YtJ5t0QeO6BNCuOboDerCrT8Xu/xgvtaEFkfE71Wu5ozuI
         g4/SNGlImyt/uWVAIgsfgxcShoiuFFlbSM3SxH88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 060/879] selftests/bpf: Fix parsing of prog types in UAPI hdr for bpftool sync
Date:   Tue,  7 Jun 2022 18:52:58 +0200
Message-Id: <20220607165004.432627806@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Monnet <quentin@isovalent.com>

[ Upstream commit 4eeebce6ac4ad80ee8243bb847c98e0e55848d47 ]

The script for checking that various lists of types in bpftool remain in
sync with the UAPI BPF header uses a regex to parse enum bpf_prog_type.
If this enum contains a set of values different from the list of program
types in bpftool, it complains.

This script should have reported the addition, some time ago, of the new
BPF_PROG_TYPE_SYSCALL, which was not reported to bpftool's program types
list. It failed to do so, because it failed to parse that new type from
the enum. This is because the new value, in the BPF header, has an
explicative comment on the same line, and the regex does not support
that.

Let's update the script to support parsing enum values when they have
comments on the same line.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220404140944.64744-1-quentin@isovalent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_bpftool_synctypes.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
index 6bf21e47882a..c0e7acd698ed 100755
--- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
+++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
@@ -180,7 +180,7 @@ class FileExtractor(object):
         @enum_name: name of the enum to parse
         """
         start_marker = re.compile(f'enum {enum_name} {{\n')
-        pattern = re.compile('^\s*(BPF_\w+),?$')
+        pattern = re.compile('^\s*(BPF_\w+),?(\s+/\*.*\*/)?$')
         end_marker = re.compile('^};')
         parser = BlockParser(self.reader)
         parser.search_block(start_marker)
-- 
2.35.1



