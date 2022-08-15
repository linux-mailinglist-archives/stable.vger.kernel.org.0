Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E66BB593C15
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239945AbiHOUJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbiHOUI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:08:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2D66C76A;
        Mon, 15 Aug 2022 11:55:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C088B81082;
        Mon, 15 Aug 2022 18:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5C1C433D6;
        Mon, 15 Aug 2022 18:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589731;
        bh=BvMF84voORROuVgcMzmIIaN6ggLX6ZNUuH8cGR75ojU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1EXtkMGpZwc1S672JQL76sk08W0hDBg81WO5xdTyYOcTWg7EkQficnPkv3Gv1YO5
         ftt6iMmh4Rja+SPVpj98qBpNXf33mza33XzQZmAx3raCc4hDQL92dri8nEIw91Wixj
         +LCVAd7f2D1A18Vef5tsd9H0UUG4uUshFPcVsrOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.18 0006/1095] NFSD: Clean up the show_nf_flags() macro
Date:   Mon, 15 Aug 2022 19:50:05 +0200
Message-Id: <20220815180429.565386008@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chuck Lever <chuck.lever@oracle.com>

commit bb283ca18d1e67c82d22a329c96c9d6036a74790 upstream.

The flags are defined using C macros, so TRACE_DEFINE_ENUM is
unnecessary.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/trace.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -692,12 +692,6 @@ DEFINE_CLID_EVENT(confirmed_r);
 /*
  * from fs/nfsd/filecache.h
  */
-TRACE_DEFINE_ENUM(NFSD_FILE_HASHED);
-TRACE_DEFINE_ENUM(NFSD_FILE_PENDING);
-TRACE_DEFINE_ENUM(NFSD_FILE_BREAK_READ);
-TRACE_DEFINE_ENUM(NFSD_FILE_BREAK_WRITE);
-TRACE_DEFINE_ENUM(NFSD_FILE_REFERENCED);
-
 #define show_nf_flags(val)						\
 	__print_flags(val, "|",						\
 		{ 1 << NFSD_FILE_HASHED,	"HASHED" },		\


