Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B174255045
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 23:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgH0VBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 17:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgH0VBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 17:01:24 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EBF5207F7;
        Thu, 27 Aug 2020 21:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598562083;
        bh=jjkcxKZ6dNsY8PM9iTN/MLtcVaCpYdrNjBalpQn0QKw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pK8q81XISaSFBpd8q69p3apIHwvSziYxNZ3IDq/NsXPSa/6N8YmfvfFMFfgdDQAwL
         zcbAA+yjuPJP+eORQN9EtwlTCp0m0wR4RoqCew/FPhZy528GPNvjf8hmjDi6lCmKxh
         tK80lSUYwW0JHZxRzCvvQI3hscibU/Ghykpv6rTo=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kBP1N-007FTK-Ib; Thu, 27 Aug 2020 22:01:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 27 Aug 2020 22:01:21 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] HID: core: Sanitize event code and type when mapping
 input
In-Reply-To: <nycvar.YFH.7.76.2008271132050.27422@cbobk.fhfr.pm>
References: <20200826134658.1046338-1-maz@kernel.org>
 <nycvar.YFH.7.76.2008271132050.27422@cbobk.fhfr.pm>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <2a6d7269c30de10c22580d002af9c1a3@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jikos@kernel.org, benjamin.tissoires@redhat.com, dmitry.torokhov@gmail.com, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-27 10:33, Jiri Kosina wrote:
> On Wed, 26 Aug 2020, Marc Zyngier wrote:
> 
>> When calling into hid_map_usage(), the passed event code is
>> blindly stored as is, even if it doesn't fit in the associated bitmap.
>> 
>> This event code can come from a variety of sources, including devices
>> masquerading as input devices, only a bit more "programmable".
>> 
>> Instead of taking the event code at face value, check that it actually
>> fits the corresponding bitmap, and if it doesn't:
>> - spit out a warning so that we know which device is acting up
>> - NULLify the bitmap pointer so that we catch unexpected uses
>> 
>> Code paths that can make use of untrusted inputs can now check
>> that the mapping was indeed correct and bail out if not.
>> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>> * From v1:
>>   - Dropped the input.c changes, and turned hid_map_usage() into
>>     the validation primitive.
>>   - Handle mapping failures in hidinput_configure_usage() and
>>     mt_touch_input_mapping() (on top of hid_map_usage_clear() which
>>     was already handled)
> 
> Benjamin, could you please run this through your regression testing
> machinery?
> 
> It's a non-trivial core change, at the same time I'd like not to 
> postpone
> it for 5.10 due to its nature.

I found yet another nit that this patch doesn't quite catch.
v3 going out in a minute.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
