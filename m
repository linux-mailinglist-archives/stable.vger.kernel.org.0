Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF32496081
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 15:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349171AbiAUOLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 09:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344906AbiAUOLs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 09:11:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E772C061574;
        Fri, 21 Jan 2022 06:11:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A4036175E;
        Fri, 21 Jan 2022 14:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB94C340E1;
        Fri, 21 Jan 2022 14:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642774307;
        bh=aU/a/VZKaBk3Zf+73rhngb0wPbazkC1pZlQcUuQUeoc=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=Yf3jweMEulrli5G6DUs3aDkFmS5QrvfDpOSW1U97G7HhJV+uu69c24T/rkVd79r3h
         hmXeTVFZPw4D0bq1KwzVjIUk5PQZHSQII1LUHH2rweTS9hGRSQFBsUgHziF+6nfZpD
         YU6/iJbnrFDaTqK7CnsYp7hBgfYt+cbcvJQi80IVvfW6YYgDoCAiNqbpmLvIC7bp0S
         z3aN8+SsN3IUk65MJ2tXOuosbUIvx6F3MB2/oeZ0zmeCXAoW8nGJ57sTd/PSgY5LgH
         HkltPx4JSDenLYArtOCGklK/LmKS6qdHTlG1MKvQTI8lURvZNxCjo8KBP+/Ipx8X60
         S5lFO/1ToXuUQ==
Date:   Fri, 21 Jan 2022 15:11:43 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Jason Gerecke <killertofu@gmail.com>
cc:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Joshua Dickens <Joshua@Joshua-Dickens.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        stable@vger.kernel.org, Ping Cheng <ping.cheng@wacom.com>
Subject: Re: [PATCH 1/2] HID: wacom: Reset expected and received contact
 counts at the same time
In-Reply-To: <20220118223756.45624-1-jason.gerecke@wacom.com>
Message-ID: <nycvar.YFH.7.76.2201211511330.28059@cbobk.fhfr.pm>
References: <20220118223756.45624-1-jason.gerecke@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Jan 2022, Jason Gerecke wrote:

> These two values go hand-in-hand and must be valid for the driver to
> behave correctly. We are currently lazy about updating the values and
> rely on the "expected" code flow to take care of making sure they're
> valid at the point they're needed. The "expected" flow changed somewhat
> with commit f8b6a74719b5 ("HID: wacom: generic: Support multiple tools
> per report"), however. This led to problems with the DTH-2452 due (in
> part) to *all* contacts being fully processed -- even those past the
> expected contact count. Specifically, the received count gets reset to
> 0 once all expected fingers are processed, but not the expected count.
> The rest of the contacts in the report are then *also* processed since
> now the driver thinks we've only processed 0 of N expected contacts.
> 
> Later commits such as 7fb0413baa7f (HID: wacom: Use "Confidence" flag to
> prevent reporting invalid contacts) worked around the DTH-2452 issue by
> skipping the invalid contacts at the end of the report, but this is not
> a complete fix. The confidence flag cannot be relied on when a contact
> is removed (see the following patch), and dealing with that condition
> re-introduces the DTH-2452 issue unless we also address this contact
> count laziness. By resetting expected and received counts at the same
> time we ensure the driver understands that there are 0 more contacts
> expected in the report. Similarly, we also make sure to reset the
> received count if for some reason we're out of sync in the pre-report
> phase.
> 
> Link: https://github.com/linuxwacom/input-wacom/issues/288
> Fixes: f8b6a74719b5 ("HID: wacom: generic: Support multiple tools per report")
> CC: stable@vger.kernel.org
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Reviewed-by: Ping Cheng <ping.cheng@wacom.com>

Both patches applied, thanks.

-- 
Jiri Kosina
SUSE Labs

