Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D93449EF8
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 00:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240894AbhKHXXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 18:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbhKHXXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 18:23:43 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F75AC061570
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 15:20:55 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id o8so68957829edc.3
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 15:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lwIQuGBsn7Be23bmYjcf+aNAhriSmibVwiA5fi4nHNg=;
        b=nWqR3niUi8ZAlpGTH8M2PlMiONtnzBQ4ATovgndU9GxTAENtI7bOL+JGzlAaf1jzq5
         sOiY2+euFxGC/cOsFw7QybnynMvkJkSjyaBCQnFcfxq9Ur70Drcep9CA7Uxc9kDWGND6
         TFUm2dlG3O0UVpWdt1MCGpuCBdMNGxBKSnUceXfy3vQ5V0zIBQn/MNtGDA3NC6LvIpyA
         gRcjbmfWelZoikQX4G6ZaFZfQoZDT3LWCD8baoYTfrDZI8uoOG8cCC+dI1G+CudV7/FV
         cqKIBvUar0aF9IrOtefg7Fmf2JSMfrqfz7oJz9X52A+wooChgbIi5Z1GLteLyrX7yNuh
         gxPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lwIQuGBsn7Be23bmYjcf+aNAhriSmibVwiA5fi4nHNg=;
        b=DZE3+avCvmAGCWXsM4LmLWISgUMHGYJ7EHe9hnFyOeGL4KIFSzoz4Zzcl6sBHn7z/Y
         CRVDRoKeEwzyV5jFj0y6wT/HydhmhtEx55uVdWkkWz9wQGI9Vkl0dfzQflJEydu7MDGM
         OtfOWtqakigmXZ3O3SIYq4TSQmk/tQv19qcgS632TdutITyq2H2Efo4vmJrUt2v0hCCT
         VaWSR/HVSZl7Mp74xc5EUatK8/eAW9RohxEFZ9ksqvtftFUOUBDA82gLGOyBlOd/CEKv
         bbfbLBWXAfd8voISH3+m+uEyMbho1ZtBjFirSZsjJGT2IiI2Ujm9xKbdVZMSVPOYfbtW
         LP2g==
X-Gm-Message-State: AOAM532c5IUt3aIj+QY64r9YbA9L0m73ADYHgFW/pYG0f2IkV2fF+Ncy
        dKOAtxqscd6SDdpGncFwUoVA0qXjRnWlPSs7sF149g==
X-Google-Smtp-Source: ABdhPJwTKbnqqSkppB5nGDfkjunaz4LA5vbuU6JW5kUVVhDDBNymoBRQ2b3G931U7pcKAAoDuVO62ro+gzidCYTi1V8=
X-Received: by 2002:a50:d984:: with SMTP id w4mr3704451edj.375.1636413653922;
 Mon, 08 Nov 2021 15:20:53 -0800 (PST)
MIME-Version: 1.0
References: <CADyq12yY25-LS8cV5LY-C=6_0HLPVZbSJCKtCDJm+wyHQSeVTg@mail.gmail.com>
 <cb682c8a-255e-28e5-d4e0-0981c2ab6ffd@intel.com> <85925a39-37c3-a79a-a084-51f2f291ca9c@intel.com>
In-Reply-To: <85925a39-37c3-a79a-a084-51f2f291ca9c@intel.com>
From:   Brian Geffon <bgeffon@google.com>
Date:   Mon, 8 Nov 2021 18:20:18 -0500
Message-ID: <CADyq12z+uOaY3Qz2g+bed4BMoVxikFSmDTDzLCuJzRVEuNpkLA@mail.gmail.com>
Subject: Re: XSAVE / RDPKRU on Intel 11th Gen Core CPUs
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> One more thing...  Does the protection_keys kernel selftest hit any
> errors on this same setup?  It does a lot of PKRU sanity checking and
> I'm a bit surprised it hasn't caught something yet.

I'll do a little more testing and get back to you.
