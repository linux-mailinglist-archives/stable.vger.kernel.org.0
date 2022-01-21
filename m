Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4116E496084
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 15:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350678AbiAUOMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 09:12:07 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:32850 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344906AbiAUOMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 09:12:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D74ACCE2257;
        Fri, 21 Jan 2022 14:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE4EC340E1;
        Fri, 21 Jan 2022 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642774323;
        bh=dJVzX8AqdFEZTA6/cEJjBrcTDRe91D49kYaTPY+SeFg=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=jTEbATWXAR6fgcNIRjcbEziTnM4fd2HMkYlC5sWnluVTfiZgCWM2oYoRltyGscpTK
         dzwysrh1frD2a5qjta/BKpYHQmS2L9jA7hknFdM6r/F8TRLi4B9MdXsYxP5lKGssNT
         4ZAiggHc1NusOBiip23ZtpSzwsudEHqhCxTcMqT6YTqiHWQ3IpSQhReDjKTZjPzR9h
         pJfnOBqK4Hm2IZThmUdEmBpU+KnETtphHXmFhhk6j6xlv+UTpsOlAFf1S0Dtjc0HPb
         dbvVq1WwOxR6CC0IeS402afA1YwOIlzjObgnDg6VmuBUUHnYuDw48SkdAX0sWhREN3
         azBvFI0iQttnQ==
Date:   Fri, 21 Jan 2022 15:11:59 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Jason Gerecke <killertofu@gmail.com>
cc:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Joshua Dickens <Joshua@Joshua-Dickens.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        stable@vger.kernel.org, Ping Cheng <ping.cheng@wacom.com>
Subject: Re: [PATCH] HID: wacom: Avoid using stale array indicies to read
 contact count
In-Reply-To: <20220118223841.45870-1-jason.gerecke@wacom.com>
Message-ID: <nycvar.YFH.7.76.2201211511490.28059@cbobk.fhfr.pm>
References: <20220118223841.45870-1-jason.gerecke@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Jan 2022, Jason Gerecke wrote:

> If we ever see a touch report with contact count data we initialize
> several variables used to read the contact count in the pre-report
> phase. These variables are never reset if we process a report which
> doesn't contain a contact count, however. This can cause the pre-
> report function to trigger a read of arbitrary memory (e.g. NULL
> if we're lucky) and potentially crash the driver.
> 
> This commit restores resetting of the variables back to default
> "none" values that were used prior to the commit mentioned
> below.
> 
> Link: https://github.com/linuxwacom/input-wacom/issues/276
> Fixes: 003f50ab673c (HID: wacom: Update last_slot_field during pre_report phase)
> CC: stable@vger.kernel.org
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Reviewed-by: Ping Cheng <ping.cheng@wacom.com>

Applied, thank you.

-- 
Jiri Kosina
SUSE Labs

