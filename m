Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F525388C6
	for <lists+stable@lfdr.de>; Tue, 31 May 2022 00:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240539AbiE3WH2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 30 May 2022 18:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbiE3WH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 18:07:27 -0400
X-Greylist: delayed 431 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 May 2022 15:07:26 PDT
Received: from relay5.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996254D26D
        for <stable@vger.kernel.org>; Mon, 30 May 2022 15:07:25 -0700 (PDT)
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay01.hostedemail.com (Postfix) with ESMTP id B5E396031E;
        Mon, 30 May 2022 22:00:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id 96F2360010;
        Mon, 30 May 2022 22:00:06 +0000 (UTC)
Date:   Tue, 31 May 2022 00:00:06 +0200
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_tracing/kprobes=3A_Check_whether_get=5Fk?= =?US-ASCII?Q?retprobe=28=29_returns_NULL_in_kretprobe=5Fdispatcher=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <0204f480-cdb0-e49f-9034-602eced02966@iogearbox.net>
References: <165366693881.797669.16926184644089588731.stgit@devnote2> <0204f480-cdb0-e49f-9034-602eced02966@iogearbox.net>
Message-ID: <7619DB57-C39B-4A49-808C-7ACF12D58592@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 96F2360010
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        KHOP_HELO_FCRDNS,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Stat-Signature: c5jjitb71wxu61mgg3cdk4ifxq19mnzc
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19SJ4DA/RUAg8tgaymn2dO+x7FzwARsHRg=
X-HE-Tag: 1653948006-138409
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On May 30, 2022 9:33:23 PM GMT+02:00, Daniel Borkmann <daniel@iogearbox.net> wrote:
>On 5/27/22 5:55 PM, Masami Hiramatsu (Google) wrote:
>> From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
>> 
>> There is a small chance that get_kretprobe(ri) returns NULL in
>> kretprobe_dispatcher() when another CPU unregisters the kretprobe
>> right after __kretprobe_trampoline_handler().
>> 
>> To avoid this issue, kretprobe_dispatcher() checks the get_kretprobe()
>> return value again. And if it is NULL, it returns soon because that
>> kretprobe is under unregistering process.
>> 
>> This issue has been introduced when the kretprobe is decoupled
>> from the struct kretprobe_instance by commit d741bf41d7c7
>> ("kprobes: Remove kretprobe hash"). Before that commit, the
>> struct kretprob_instance::rp directly points the kretprobe
>> and it is never be NULL.
>> 
>> Reported-by: Yonghong Song <yhs@fb.com>
>> Fixes: d741bf41d7c7 ("kprobes: Remove kretprobe hash")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
>
>Steven, I presume you'll pick this fix up?

I'm currently at Embedded/Kernel Recipes, but yeah, I'll take a look at it. (Just need to finish my slides first ;-)

-- Steve
>
>Thanks,
>Daniel

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity and top posting.
