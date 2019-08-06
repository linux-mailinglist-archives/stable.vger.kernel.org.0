Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDDD82FF3
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 12:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728845AbfHFKqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 06:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbfHFKqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 06:46:53 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAED520818;
        Tue,  6 Aug 2019 10:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565088412;
        bh=nW8mCCcPnaGE1IapBBAhGxQEOcRlhJPsGDcq9sFWs68=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=1USLhnwTzze5zoPkXb/z47h6Iaka5qhFSIdsouPxESInJ6OjZNU2MhBP7c8udB/0c
         ReZX9RgaOAh5s91Ph12f44J1hpViRNhxAkwPucQCWl9p1eo9Qf+WoLDXJ0ccGxxijH
         hQpLvzjMH0IGubDu4egLYd6/pTRAHBYQzOqtkD5Q=
Date:   Tue, 6 Aug 2019 12:46:47 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Roderick Colenbrander <roderick@gaikai.com>
cc:     linux-input@vger.kernel.org, benjamin.tissoires@redhat.com,
        svv@google.com, pgriffais@valvesoftware.com,
        Roderick Colenbrander <roderick.colenbrander@sony.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] HID: sony: Fix race condition between rumble and device
 remove.
In-Reply-To: <20190802225019.2418-1-roderick@gaikai.com>
Message-ID: <nycvar.YFH.7.76.1908061246320.27147@cbobk.fhfr.pm>
References: <20190802225019.2418-1-roderick@gaikai.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2 Aug 2019, Roderick Colenbrander wrote:

> Valve reported a kernel crash on Ubuntu 18.04 when disconnecting a DS4
> gamepad while rumble is enabled. This issue is reproducible with a
> frequency of 1 in 3 times in the game Borderlands 2 when using an
> automatic weapon, which triggers many rumble operations.
> 
> We found the issue to be a race condition between sony_remove and the
> final device destruction by the HID / input system. The problem was
> that sony_remove didn't clean some of its work_item state in
> "struct sony_sc". After sony_remove work, the corresponding evdev
> node was around for sufficient time for applications to still queue
> rumble work after "sony_remove".
> 
> On pre-4.19 kernels the race condition caused a kernel crash due to a
> NULL-pointer dereference as "sc->output_report_dmabuf" got freed during
> sony_remove. On newer kernels this crash doesn't happen due the buffer
> now being allocated using devm_kzalloc. However we can still queue work,
> while the driver is an undefined state.
> 
> This patch fixes the described problem, by guarding the work_item
> "state_worker" with an initialized variable, which we are setting back
> to 0 on cleanup.

Applied to for-5.3/upstream-fixes. Thanks,

-- 
Jiri Kosina
SUSE Labs

