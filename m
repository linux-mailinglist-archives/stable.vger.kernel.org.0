Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C85CDCC5
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 10:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbfJGIC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 04:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727224AbfJGIC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 04:02:29 -0400
Received: from [10.33.87.18] (twin.jikos.cz [91.219.245.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CECD20867;
        Mon,  7 Oct 2019 08:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570435348;
        bh=DbrpAfomurrCCdFD0IJeUwRw1yWRYID3uypVq0D8MQw=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=ILBNzhemPwPmbQnaC2LVrUnAx54C/R93wfWv1G86UaG8h1UKlITDQ2NQj8Y09JZjM
         B6xS9BAgcVSnQ/aOy+/+snNJS3s0TNmJiUt4QkMuI+50OcVJ03oqyCnztKugeo0x4g
         R+lPPA2M1btyA+m1tgijqbN/px5ni5HfUoG7g40Q=
Date:   Mon, 7 Oct 2019 10:02:11 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Will Deacon <will@kernel.org>
cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Petr Mladek <pmladek@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, contact@xogium.me
Subject: Re: [PATCH] panic: Ensure preemption is disabled during panic()
In-Reply-To: <20191004104947.vbxe5kv3nbjxqs55@willie-the-truck>
Message-ID: <nycvar.YEU.7.76.1910071000170.15186@gjva.wvxbf.pm>
References: <20191002123538.22609-1-will@kernel.org> <201910021355.E578D2FFAF@keescook> <20191003205633.w26geqhq67u4ysit@willie-the-truck> <20191004091142.57iylai22aqpu6lu@pathway.suse.cz> <20191004092917.GY25745@shell.armlinux.org.uk>
 <20191004104947.vbxe5kv3nbjxqs55@willie-the-truck>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 4 Oct 2019, Will Deacon wrote:

> Indeed, and I think the LED blinking is already unreliable if the
> brightness operation needs to sleep. 

One thing is that led_set_brightness() can probably be forced to avoid the 
workqueue scheduling, by setting LED_BLINK_SW on the device (e.g. by 
issuing led_set_software_blink() during panic).

But I am afraid this still won't solve the issue completely, as USB 
keyboards need workqueues for blinking the LEDs in for URB management.

-- 
Jiri Kosina
SUSE Labs
