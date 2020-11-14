Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889982B314C
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 23:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgKNW6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 17:58:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgKNW6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Nov 2020 17:58:52 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D321E24073;
        Sat, 14 Nov 2020 22:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605394732;
        bh=mWo9BhwcebEeYNtQDho2WW/HLm5sQAVSBBwcsj5iFts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TTjjkSwxxRCE4dwgHBavciPrI3W5heX94zUgtHV9pBQCqrPLv2u0bdCBs5qk4Mz5g
         7NVSJl3uZobCrrx602q+sTjLWl9N6RNyYxqfI0mKPnU8Y+JB6KnJh7WT6VxC4Uo5wE
         cRCCkRWC/ZkbN/B2nwxV6I8/W5O6uokykuNXqdAY=
Date:   Sat, 14 Nov 2020 17:58:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH AUTOSEL 4.19 18/21] kprobes: Tell lockdep about kprobe
 nesting
Message-ID: <20201114225850.GH403069@sasha-vm>
References: <20201110035541.424648-1-sashal@kernel.org>
 <20201110035541.424648-18-sashal@kernel.org>
 <20201110154458.546c220fcae09592cf5282b9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201110154458.546c220fcae09592cf5282b9@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 10, 2020 at 03:44:58PM +0900, Masami Hiramatsu wrote:
>Hi,
>
>On Mon,  9 Nov 2020 22:55:38 -0500
>Sasha Levin <sashal@kernel.org> wrote:
>
>> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>>
>> [ Upstream commit 645f224e7ba2f4200bf163153d384ceb0de5462e ]
>>
>> Since the kprobe handlers have protection that prohibits other handlers from
>> executing in other contexts (like if an NMI comes in while processing a
>> kprobe, and executes the same kprobe, it will get fail with a "busy"
>> return). Lockdep is unaware of this protection. Use lockdep's nesting api to
>> differentiate between locks taken in INT3 context and other context to
>> suppress the false warnings.
>>
>> Link: https://lore.kernel.org/r/20201102160234.fa0ae70915ad9e2b21c08b85@kernel.org
>>
>
>This fixes a lockdep false positive warning comes from commit e03b4a084ea6
>("kprobes: Remove NMI context check"). Does anyone report that happen on the
>stable kernel?
>
>If not, you do not need this patch for stable kernels.

I'll drop it, thanks!

-- 
Thanks,
Sasha
