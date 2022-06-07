Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8152D540755
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347894AbiFGRq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348269AbiFGRpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:45:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A9B120883;
        Tue,  7 Jun 2022 10:35:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3231060DB5;
        Tue,  7 Jun 2022 17:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33683C385A5;
        Tue,  7 Jun 2022 17:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623302;
        bh=GFhTLhJTvJOP/bzJqqPLs/y6x9JjTw48Vkdr80rkDWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lD0l8LEIEejocZ6uDW9bBXMTs88BhmPJrrzzGzCanAuTFwWSHH4NJQAEWsVDjqJ5f
         0MnuscA98rIXzXFElJ9vnxZxIr329xNn/VknXsrUSZEP1gUoCca+qc9315pOqbAGzS
         lIUaLmyziSxMFY7S/SkJhrkaWe1d0YPgmmxDPUFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 367/452] tracing: Fix potential double free in create_var_ref()
Date:   Tue,  7 Jun 2022 19:03:44 +0200
Message-Id: <20220607164919.499036495@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

From: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>

commit 99696a2592bca641eb88cc9a80c90e591afebd0f upstream.

In create_var_ref(), init_var_ref() is called to initialize the fields
of variable ref_field, which is allocated in the previous function call
to create_hist_field(). Function init_var_ref() allocates the
corresponding fields such as ref_field->system, but frees these fields
when the function encounters an error. The caller later calls
destroy_hist_field() to conduct error handling, which frees the fields
and the variable itself. This results in double free of the fields which
are already freed in the previous function.

Fix this by storing NULL to the corresponding fields when they are freed
in init_var_ref().

Link: https://lkml.kernel.org/r/20220425063739.3859998-1-keitasuzuki.park@sslab.ics.keio.ac.jp

Fixes: 067fe038e70f ("tracing: Add variable reference handling to hist triggers")
CC: stable@vger.kernel.org
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1789,8 +1789,11 @@ static int init_var_ref(struct hist_fiel
 	return err;
  free:
 	kfree(ref_field->system);
+	ref_field->system = NULL;
 	kfree(ref_field->event_name);
+	ref_field->event_name = NULL;
 	kfree(ref_field->name);
+	ref_field->name = NULL;
 
 	goto out;
 }


