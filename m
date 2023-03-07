Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362956AED31
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjCGSCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjCGSBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:01:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71205AA268
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:55:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5100A6150B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657C6C433D2;
        Tue,  7 Mar 2023 17:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211718;
        bh=iYX5qWHMaH8B8G9kRwtvIs+1rTAjqHYKdfBR7y97xeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=op3Xn/fwmMvUM0r5osdUTLJdP7/6bzhmtaMrEQetRRCU/ZgfSdhkOtu98DLzInVal
         nDG2eGxTqF8C2QijhB7bh6iKttpJoOIPJtxizKmwsOoeQ4hVOfEeoEp0MBfn5/CN1k
         JngfsgAeNeUVlfHkNnnmccRFAXyTABSTPPpiByeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Antonio Alvarez Feijoo <antonio.feijoo@suse.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.2 0953/1001] tools/bootconfig: fix single & used for logical condition
Date:   Tue,  7 Mar 2023 18:02:05 +0100
Message-Id: <20230307170103.505918598@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antonio Alvarez Feijoo <antonio.feijoo@suse.com>

commit cf8c59a3756b2735c409a9b3ac1e4ec556546a7a upstream.

A single & will create a background process and return true, so the grep
command will run even if the file checked in the first condition does not
exist.

Link: https://lore.kernel.org/all/20230112114215.17103-1-antonio.feijoo@suse.com/

Fixes: 1eaad3ac3f39 ("tools/bootconfig: Use per-group/all enable option in ftrace2bconf script")
Signed-off-by: Antonio Alvarez Feijoo <antonio.feijoo@suse.com>
Cc: stable@vger.kernel.org
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bootconfig/scripts/ftrace2bconf.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/bootconfig/scripts/ftrace2bconf.sh
+++ b/tools/bootconfig/scripts/ftrace2bconf.sh
@@ -93,7 +93,7 @@ referred_vars() {
 }
 
 event_is_enabled() { # enable-file
-	test -f $1 & grep -q "1" $1
+	test -f $1 && grep -q "1" $1
 }
 
 per_event_options() { # event-dir


