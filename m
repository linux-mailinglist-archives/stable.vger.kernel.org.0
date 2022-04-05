Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E504F2AC0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbiDEJDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236772AbiDEIRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27531ADD4C;
        Tue,  5 Apr 2022 01:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DB47B81BBF;
        Tue,  5 Apr 2022 08:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39E9C385A1;
        Tue,  5 Apr 2022 08:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145853;
        bh=61JOj3rc2LxFRa0F8Npl5jgFEtUFrS1lDJOqF8od3/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GoAhyYlLbTBrls4SfVS67pW2sHCEgdzAKrADwJbXP6FmOpBgZFiQJZ9ZxGqSJmZRx
         gYczMZq+Areh4Zc/INMndtkUC+JW61wddzbBEV8ZlpHwU/Frmdb7MVoqt+QekxWQLf
         vPGygBPQt8OWQ6jrlT32J1BFDK9OKy8nUdmGoE0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bracht Laumann Jespersen <t@laumann.xyz>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0514/1126] scripts/dtc: Call pkg-config POSIXly correct
Date:   Tue,  5 Apr 2022 09:21:01 +0200
Message-Id: <20220405070422.715732029@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bracht Laumann Jespersen <t@laumann.xyz>

[ Upstream commit a8b309ce9760943486e0585285e0125588a31650 ]

Running with POSIXLY_CORRECT=1 in the environment the scripts/dtc build
fails, because pkg-config doesn't output anything when the flags come
after the arguments.

Fixes: 067c650c456e ("dtc: Use pkg-config to locate libyaml")
Signed-off-by: Thomas Bracht Laumann Jespersen <t@laumann.xyz>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220131112028.7907-1-t@laumann.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/dtc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/dtc/Makefile b/scripts/dtc/Makefile
index 95aaf7431bff..1cba78e1dce6 100644
--- a/scripts/dtc/Makefile
+++ b/scripts/dtc/Makefile
@@ -29,7 +29,7 @@ dtc-objs	+= yamltree.o
 # To include <yaml.h> installed in a non-default path
 HOSTCFLAGS_yamltree.o := $(shell pkg-config --cflags yaml-0.1)
 # To link libyaml installed in a non-default path
-HOSTLDLIBS_dtc	:= $(shell pkg-config yaml-0.1 --libs)
+HOSTLDLIBS_dtc	:= $(shell pkg-config --libs yaml-0.1)
 endif
 
 # Generated files need one more search path to include headers in source tree
-- 
2.34.1



