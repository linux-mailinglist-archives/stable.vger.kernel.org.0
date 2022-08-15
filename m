Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1CE5934B1
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbiHOSOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbiHOSOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:14:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5974A2A733;
        Mon, 15 Aug 2022 11:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDB766126D;
        Mon, 15 Aug 2022 18:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE28AC433C1;
        Mon, 15 Aug 2022 18:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587236;
        bh=ZijTKWQteD+IeC1G+H3UDJt9gaxBn9cocLeNx6vahE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJNWOy+Il0xNfE+qTkArvltRvhqs5tcNtOk01URTRn9ZLFj7ITul/1qF7uYWelpwu
         ToUa1fY8PzP8TjjQbVbTKBhHotRHxBS3OuY442r5RzXBXivmypHFc+RhUHWxiWh4yD
         OkPVxFZ3mIXpEkRfHal7q4AWqvGmeSBL+L90AO60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 006/779] NFSD: Clean up the show_nf_flags() macro
Date:   Mon, 15 Aug 2022 19:54:10 +0200
Message-Id: <20220815180337.442654455@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
@@ -636,12 +636,6 @@ DEFINE_CLID_EVENT(confirmed_r);
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


