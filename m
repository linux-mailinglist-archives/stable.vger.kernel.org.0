Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9D21DDBC2
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 02:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgEVAJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 20:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730255AbgEVAJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 20:09:36 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFF322078B;
        Fri, 22 May 2020 00:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590106176;
        bh=VT6rgSIyosdUHrRtnNMoLLYHXaPFQ3aDF5yVyjZocns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FvRFViMZISnnMFcVtk6MiH5qO8KEuYbrow26PQPwyC3rafu94ILMA6SKkOxNr7soT
         eHSxg13t+leL3rWaU/Vu9R5uCIBfV3pmenEUbYyddpke0d9P7NhPVfvlgbBnhcjF7O
         jAXSQ1j6WEKpQ9tuy82Rj869mBpK53N970XQywOI=
Date:   Thu, 21 May 2020 20:09:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     stable@vger.kernel.org, kernel-team@cloudflare.com,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [PATCH 4.19.y] selftests: bpf: fix use of undeclared RET_IF macro
Message-ID: <20200522000934.GM33628@sasha-vm>
References: <20200521144841.7074-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200521144841.7074-1-lmb@cloudflare.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 21, 2020 at 03:48:41PM +0100, Lorenz Bauer wrote:
>commit 634efb750435 ("selftests: bpf: Reset global state between
>reuseport test runs") uses a macro RET_IF which doesn't exist in
>the v4.19 tree. It is defined as follows:
>
>        #define RET_IF(condition, tag, format...) ({
>                if (CHECK_FAIL(condition)) {
>                        printf(tag " " format);
>                        return;
>                }
>        })
>
>CHECK_FAIL in turn is defined as:
>
>        #define CHECK_FAIL(condition) ({
>                int __ret = !!(condition);
>                int __save_errno = errno;
>                if (__ret) {
>                        test__fail();
>                        fprintf(stdout, "%s:FAIL:%d\n", __func__, __LINE__);
>                }
>                errno = __save_errno;
>                __ret;
>        })
>
>Replace occurences of RET_IF with CHECK. This will abort the test binary
>if clearing the intermediate state fails.
>
>Fixes: 634efb750435 ("selftests: bpf: Reset global state between reuseport test runs")
>Reported-by: kernel test robot <rong.a.chen@intel.com>
>Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>

Thanks for the backport Lorenz. We'll need to wait for it to make it
into Linus's tree before queueing up for the stable trees.

-- 
Thanks,
Sasha
