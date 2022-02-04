Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D004A9707
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239093AbiBDJmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiBDJmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:42:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D9EC061714;
        Fri,  4 Feb 2022 01:42:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3356EB835FF;
        Fri,  4 Feb 2022 09:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117B6C004E1;
        Fri,  4 Feb 2022 09:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643967763;
        bh=toQRlag89WgoQbDeLsTnM9vrf7XzsnptbqFZ8LVPtz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=18/5wzarpQIWSe2Licy66VUq6gWXg04CPuIVqZ/YgyEi26YbQLVAewIYss8sUg/P8
         efbZEriHeXdn+lg+Ahg17MsdiAZq1kFOGhyGHYwRubcSgmi4LeaiI+YJl4GyQJDjJ7
         2j6y0sZV+YwJ90uqu7NWhK/K87P8D10gGeqDJsRg=
Date:   Fri, 4 Feb 2022 10:40:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marco Elver <elver@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: Re: [PATCH 5.10 08/25] perf: Rework perf_event_exit_event()
Message-ID: <Yfz0nWtyap5Y3ogJ@kroah.com>
References: <20220204091914.280602669@linuxfoundation.org>
 <20220204091914.560626177@linuxfoundation.org>
 <20220204093734.GA27857@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204093734.GA27857@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 04, 2022 at 10:37:35AM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Peter Zijlstra <peterz@infradead.org>
> > 
> > commit ef54c1a476aef7eef26fe13ea10dc090952c00f8 upstream.
> > 
> > Make perf_event_exit_event() more robust, such that we can use it from
> > other contexts. Specifically the up and coming remove_on_exec.
> 
> Do we need this in 5.10? AFAICT the remove_on_exec work is not queued
> for 5.10, and this patch is buggy and needs following one to fix it
> up.

It's needed by the following patch, which says 5.10 is affected.
