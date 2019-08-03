Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D9880764
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 19:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbfHCRPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 13:15:00 -0400
Received: from aibo.runbox.com ([91.220.196.211]:39646 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728106AbfHCRPA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Aug 2019 13:15:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=rbselector1; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
        References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
        bh=AUt0lZ5cBBxqfZLtJfweD6s6Tb2CAblPo27t2+VxX48=; b=oHRnJjBDPUl9m8IZ7yPHgb/1ZF
        2EBQsP5kJFKNVu4bVsKxjnDKqC5Y0fE+AJql3pb1+jkWlkO7eGdZB82yVree83ex0I71nB147A7YF
        z8PR0EUcugXTOSNHT/A52POZmuqoC7lSRseJKWqy+MSg52MgkHHDSJuCBb7+l0JjLdqEUE4f6DAGc
        Gjv5H2Siw1gQNXaBrm/qcY34SQu8Qokyw7bKH3+dYt26kYV3SUViyHrQvg/8kJMin+M1c93Tg/NuN
        qg24UFgm28KVpyR3MLfk2LkNW/dlQM22Tl4Qh3VS7/s/RzC3Xx/6L9Lyk80fSZVgI01a0ahq1m87Q
        6hN//zZA==;
Received: from [10.9.9.203] (helo=mailfront21.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1htxcL-0007cG-2V; Sat, 03 Aug 2019 19:14:53 +0200
Received: by mailfront21.runbox with esmtpsa  (uid:769847 )  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1htxbt-0004ud-23; Sat, 03 Aug 2019 19:14:25 +0200
Date:   Sat, 3 Aug 2019 13:14:19 -0400
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] kconfig: Clear "written" flag to avoid data loss
Message-ID: <20190803131419.394911de@runbox.com>
In-Reply-To: <20190803132212.1849D2075C@mail.kernel.org>
References: <20190803100212.8227-1-m.v.b@runbox.com>
        <20190803132212.1849D2075C@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 03 Aug 2019 13:22:11 +0000
Sasha Levin <sashal@kernel.org> wrote:

> Hi,
> 
> [This is an automated email]

Hello,

Sorry about the late reply.
 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 8e2442a5f86e kconfig: fix missing choice values in
> auto.conf.
> 
> The bot has tested the following trees: v5.2.5, v4.19.63.
> 
> v5.2.5: Build OK!
> v4.19.63: Failed to apply! Possible dependencies:
>     aff11cd983ec ("kconfig: Terminate menu blocks with a comment in
> the generated config")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is
> upstream.
> 
> How should we proceed with this patch?

The merge conflict is a very minor one involving the difference between
the following two code blocks:

v4.19.y
	const char *str;
	char dirname[PATH_MAX+1], tmpname[PATH_MAX+22],
	newname[PATH_MAX+8]; char *env;

next/master (and v5.2.y)
	const char *str;
	char tmpname[PATH_MAX + 1], oldname[PATH_MAX + 1];
	char *env;
	bool need_newline = false;

This patch inserts the variable "int i;" between "char *env;" and
"bool need_newline = false;", but this does not work due to v4.19.y not
having the same context.

> --
> Thanks,
> Sasha

Thank you,

Vefa
