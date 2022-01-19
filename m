Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCC9493C6B
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 15:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355370AbiASO7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 09:59:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52882 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349566AbiASO7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 09:59:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6737B61325;
        Wed, 19 Jan 2022 14:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6780CC004E1;
        Wed, 19 Jan 2022 14:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642604390;
        bh=Co6GqO2izoHEvb/easQuwemJ2ju1jNCgw+sJ4K1Ty4Y=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=VL4STJPe0VttSVxK9oVqxhtUWcEQg5+P62qF7F0KseezRYR31NL5uQHn3hddqW3Nf
         03/vxTTM6uDolssjxZF7Uxk+a9OtSYo43EJGqrMjaFtNRjHhmsEF1PHjkHgZE/TEJt
         6SOnkHiZhPDFB/2im3Iji/6QIMQ+iQZbeEwzgnH8mslJJQ00H0CUadNAda2W/gvUB3
         AbDCT4eBOAw8Qc0mftnGlcRIRikwBzKVnl4Pg+s4fQmWNU+mf2yeQskeUPtKOPBdbx
         XjpbqNWdkVAtjiG5hzfLEu3x8Hi0XtiSfwZ5WuoZ5a7I8aQ5k1ZuE1OIHyuqgwQP3/
         lxf3lRt8xLonQ==
Date:   Wed, 19 Jan 2022 15:59:47 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Jann Horn <jannh@google.com>
cc:     David Rheinsberg <david.rheinsberg@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org,
        Roderick Colenbrander <roderick.colenbrander@sony.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: uhid: Fix worker destroying device without any
 protection
In-Reply-To: <20220114133331.873057-1-jannh@google.com>
Message-ID: <nycvar.YFH.7.76.2201191559280.28059@cbobk.fhfr.pm>
References: <20220114133331.873057-1-jannh@google.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 Jan 2022, Jann Horn wrote:

> uhid has to run hid_add_device() from workqueue context while allowing
> parallel use of the userspace API (which is protected with ->devlock).
> But hid_add_device() can fail. Currently, that is handled by immediately
> destroying the associated HID device, without using ->devlock - but if
> there are concurrent requests from userspace, that's wrong and leads to
> NULL dereferences and/or memory corruption (via use-after-free).
> 
> Fix it by leaving the HID device as-is in the worker. We can clean it up
> later, either in the UHID_DESTROY command handler or in the ->release()
> handler.
> 
> Cc: stable@vger.kernel.org
> Fixes: 67f8ecc550b5 ("HID: uhid: fix timeout when probe races with IO")
> Signed-off-by: Jann Horn <jannh@google.com>

I've queued both patches for 5.17, thanks a lot for fixing this.

-- 
Jiri Kosina
SUSE Labs

