Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23051254268
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 11:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgH0JdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 05:33:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgH0JdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 05:33:13 -0400
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07105207CD;
        Thu, 27 Aug 2020 09:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598520793;
        bh=hj3WI8IjaMyp0FgWAa0QJ/wRxCb+fiu5gxIPrEPEPQ8=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=h75oHKk9C5JRAOyvDpGW+zA2Vz77XGTqhV0jO6IJ3CYDr3O/1lLSvSWW7tuZ+3B5k
         cClAj2yxblsYOdsI6wxTn2NhkL3BOeIOihR0BgcU11rpkOlDP/9G4J8fIKbBK2ZAmi
         kH1lvVYuqhHbPXHDl0YZGiUfKhETvNEmmbNqPF14=
Date:   Thu, 27 Aug 2020 11:33:10 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Marc Zyngier <maz@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] HID: core: Sanitize event code and type when mapping
 input
In-Reply-To: <20200826134658.1046338-1-maz@kernel.org>
Message-ID: <nycvar.YFH.7.76.2008271132050.27422@cbobk.fhfr.pm>
References: <20200826134658.1046338-1-maz@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Aug 2020, Marc Zyngier wrote:

> When calling into hid_map_usage(), the passed event code is
> blindly stored as is, even if it doesn't fit in the associated bitmap.
> 
> This event code can come from a variety of sources, including devices
> masquerading as input devices, only a bit more "programmable".
> 
> Instead of taking the event code at face value, check that it actually
> fits the corresponding bitmap, and if it doesn't:
> - spit out a warning so that we know which device is acting up
> - NULLify the bitmap pointer so that we catch unexpected uses
> 
> Code paths that can make use of untrusted inputs can now check
> that the mapping was indeed correct and bail out if not.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> * From v1:
>   - Dropped the input.c changes, and turned hid_map_usage() into
>     the validation primitive.
>   - Handle mapping failures in hidinput_configure_usage() and
>     mt_touch_input_mapping() (on top of hid_map_usage_clear() which
>     was already handled)

Benjamin, could you please run this through your regression testing 
machinery?

It's a non-trivial core change, at the same time I'd like not to postpone 
it for 5.10 due to its nature.

Thanks,

-- 
Jiri Kosina
SUSE Labs

