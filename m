Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88474676F46
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjAVPTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjAVPTj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:19:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9509E21954
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:19:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F8FEB80B11
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD64C433EF;
        Sun, 22 Jan 2023 15:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400776;
        bh=CcOCemWBOBJdmiaDIox2Zaxxg+IYB9jzUhtNt639Mpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chHG7jFc3ECw57FveLmZGc1O+5jQSIvT66LLGY4mRNAxL6+9WSNCTFXteUAWgqigf
         50G04EaIxFSw0I3chh/M8cQWpvYO1C+LGXZBGz37iEMlVSp2mJby05coRLIlcMQg8/
         E1Rwp4eTaEfE62s1TBEW32TwCwqfYN0mAEi7X1p0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Laight <David.Laight@ACULAB.COM>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.15 105/117] tracing: Use alignof__(struct {type b;}) instead of offsetof()
Date:   Sun, 22 Jan 2023 16:04:55 +0100
Message-Id: <20230122150237.194380757@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit 09794a5a6c348f629b35fc1687071a1622ef4265 upstream.

Simplify:

  #define ALIGN_STRUCTFIELD(type) ((int)(offsetof(struct {char a; type b;}, b)))

with

  #define  ALIGN_STRUCTFIELD(type) __alignof__(struct {type b;})

Which works just the same.

Link: https://lore.kernel.org/all/a7d202457150472588df0bd3b7334b3f@AcuMS.aculab.com/
Link: https://lkml.kernel.org/r/20220802154412.513c50e3@gandalf.local.home

Suggested-by: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/trace_events.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -479,7 +479,7 @@ static struct trace_event_functions trac
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#define ALIGN_STRUCTFIELD(type) ((int)(offsetof(struct {char a; type b;}, b)))
+#define ALIGN_STRUCTFIELD(type) ((int)(__alignof__(struct {type b;})))
 
 #undef __field_ext
 #define __field_ext(_type, _item, _filter_type) {			\


