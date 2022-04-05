Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0844F451B
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350036AbiDEMIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358051AbiDEK15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0007140A34;
        Tue,  5 Apr 2022 03:13:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5B64B81C8A;
        Tue,  5 Apr 2022 10:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91A3C385A1;
        Tue,  5 Apr 2022 10:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153632;
        bh=v41tzQEYNLJXuxNjDPBUuCncp+Z5urm4bH13/AV4ow0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kG0Srnp4ZYENgSvnjKfDxHoKqx6/ZaFpvxwZGLFM6fY6wDYR9FwIUrx636XZqRYyv
         lSZTZAD1SZ8CyWXGHB7IEo1oG7r0j43jFJa12/rqGKznzcWT/Ff8MLvUAp1iuPpnIc
         Bd/4fZbIbPGUJOkUB549WaRLsC2tBTMrYFuMhBiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bracht Laumann Jespersen <t@laumann.xyz>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 292/599] scripts/dtc: Call pkg-config POSIXly correct
Date:   Tue,  5 Apr 2022 09:29:46 +0200
Message-Id: <20220405070307.523171481@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 4852bf44e913..f1d201782346 100644
--- a/scripts/dtc/Makefile
+++ b/scripts/dtc/Makefile
@@ -22,7 +22,7 @@ dtc-objs	+= yamltree.o
 # To include <yaml.h> installed in a non-default path
 HOSTCFLAGS_yamltree.o := $(shell pkg-config --cflags yaml-0.1)
 # To link libyaml installed in a non-default path
-HOSTLDLIBS_dtc	:= $(shell pkg-config yaml-0.1 --libs)
+HOSTLDLIBS_dtc	:= $(shell pkg-config --libs yaml-0.1)
 endif
 
 # Generated files need one more search path to include headers in source tree
-- 
2.34.1



