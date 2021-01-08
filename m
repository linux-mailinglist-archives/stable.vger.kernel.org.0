Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B382EEA66
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 01:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbhAHA2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 19:28:06 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:54999 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729528AbhAHA2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 19:28:06 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4EA2622EE3;
        Fri,  8 Jan 2021 01:27:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1610065644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uvY5DT7uR8ILxdwL1txsJjiGR6Gy6AsKv0OG8O1+g7U=;
        b=HEGGQu2+s0sQ1pb/y23vwjpGPnIlttVmckrmSP3WqWqpy0XirgU3EZeunZhYrLhG3fxsC5
        6I/KT+VA/F/P2eWNbjovp5q4V9owGArmzN8OiqNPAgmIwt/odMcxDQdx2yr1HjXkius+cQ
        wrOiEWBhJpAYpg+JIz0aIfCW6m9xxuE=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 08 Jan 2021 01:27:24 +0100
From:   Michael Walle <michael@walle.cc>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] driver core: Fix device link device name collision
In-Reply-To: <b3cda25a3e3911a12a8766f141c9e300@walle.cc>
References: <20210107234136.740371-1-saravanak@google.com>
 <b3cda25a3e3911a12a8766f141c9e300@walle.cc>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <4ed3da70b825e4cbe778e9b8e4619434@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2021-01-08 01:14, schrieb Michael Walle:
> Am 2021-01-08 00:41, schrieb Saravana Kannan:
>> The device link device's name was of the form:
>> <supplier-dev-name>--<consumer-dev-name>
>> 
>> This can cause name collision as reported here [1] as device names are
>> not globally unique. Since device names have to be unique within the
>> bus/class, add the bus/class name as a prefix to the device names used 
>> to
>> construct the device link device name.
>> 
>> So the devuce link device's name will be of the form:
>> <supplier-bus-name>:<supplier-dev-name>--<consumer-bus-name>:<consumer-dev-name>
>> 
>> [1] - 
>> https://lore.kernel.org/lkml/20201229033440.32142-1-michael@walle.cc/
>> 
>> Cc: stable@vger.kernel.org
>> Fixes: 287905e68dd2 ("driver core: Expose device link details in 
>> sysfs")
>> Reported-by: Michael Walle <michael@walle.cc>
>> Signed-off-by: Saravana Kannan <saravanak@google.com>
>> ---
> 
> This makes it even worse.

Mhh, actually there are now other errors (the ones before might be 
fixed). Seems
to be truncated filenames and for the iommu ones, I don't know.

-- 
-michael
