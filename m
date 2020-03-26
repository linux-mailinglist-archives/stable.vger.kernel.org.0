Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDB1194D6F
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgCZXlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:41:39 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56868 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgCZXli (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 19:41:38 -0400
Received: from fsav109.sakura.ne.jp (fsav109.sakura.ne.jp [27.133.134.236])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 02QNfUR6064902;
        Fri, 27 Mar 2020 08:41:30 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav109.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav109.sakura.ne.jp);
 Fri, 27 Mar 2020 08:41:30 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav109.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 02QNfUCc064896
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Fri, 27 Mar 2020 08:41:30 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH AUTOSEL 5.5 23/28] kconfig: Add yes2modconfig and
 mod2yesconfig targets.
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org
References: <20200326232357.7516-1-sashal@kernel.org>
 <20200326232357.7516-23-sashal@kernel.org>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <d4546302-2dd8-0930-f478-654bfbddb642@i-love.sakura.ne.jp>
Date:   Fri, 27 Mar 2020 08:41:28 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326232357.7516-23-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello.

I'm fine with backporting this patch. But if you want to backport this patch, please also
backport 089b7d890f972f6b ("kconfig: Invalidate all symbols after changing to y or m.")
which actually makes this patch functional.

On 2020/03/27 8:23, Sasha Levin wrote:
> From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> 
> [ Upstream commit 89b9060987d988333de59dd218c9666bd7ee95a5 ]
> 
> Since kernel configs provided by syzbot are close to "make allyesconfig",
> it takes long time to rebuild. This is especially waste of time when we
> need to rebuild for many times (e.g. doing manual printk() inspection,
> bisect operations).
> 
> We can save time if we can exclude modules which are irrelevant to each
> problem. But "make localmodconfig" cannot exclude modules which are built
> into vmlinux because /sbin/lsmod output is used as the source of modules.
> 
> Therefore, this patch adds "make yes2modconfig" which converts from =y
> to =m if possible. After confirming that the interested problem is still
> reproducible, we can try "make localmodconfig" (and/or manually tune
> based on "Modules linked in:" line) in order to exclude modules which are
> irrelevant to the interested problem. While we are at it, this patch also
> adds "make mod2yesconfig" which converts from =m to =y in case someone
> wants to convert from =m to =y after "make localmodconfig".
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
