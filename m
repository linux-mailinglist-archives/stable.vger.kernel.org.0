Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675AE4F8B18
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 02:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbiDGWqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 18:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbiDGWqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 18:46:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC7C1578F7;
        Thu,  7 Apr 2022 15:44:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8070B829A6;
        Thu,  7 Apr 2022 22:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4757EC385A4;
        Thu,  7 Apr 2022 22:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649371467;
        bh=hIvqS6RVxt92RR7xvo4WKRMmb/Y56ZN8tL5vx0hkAGs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HM77SMATfGFl5LMW36PL6MtnIJvmB/XAW+fcPCI29k5nWhVpuUTY3HzmBNmIqdg3v
         uP48N1JWMBDzHVnrKsuoXOsc22VHVDUHOfbrW1ak0p4vMB9ounTiSYUk6QPs7aeNlq
         SzxKfbBfdjsvz1qfo0G3dGVoLZu5FtkwlT9+a+ME=
Date:   Thu, 7 Apr 2022 15:44:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marek =?ISO-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] mm, page_alloc: fix build_zonerefs_node()
Message-Id: <20220407154426.7076e19f5b80d927dd715de9@linux-foundation.org>
In-Reply-To: <20220407120637.9035-1-jgross@suse.com>
References: <20220407120637.9035-1-jgross@suse.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu,  7 Apr 2022 14:06:37 +0200 Juergen Gross <jgross@suse.com> wrote:

> Since commit 6aa303defb74 ("mm, vmscan: only allocate and reclaim from
> zones with pages managed by the buddy allocator")

Six years ago!

> only zones with free
> memory are included in a built zonelist. This is problematic when e.g.
> all memory of a zone has been ballooned out when zonelists are being
> rebuilt.
> 
> The decision whether to rebuild the zonelists when onlining new memory
> is done based on populated_zone() returning 0 for the zone the memory
> will be added to. The new zone is added to the zonelists only, if it
> has free memory pages (managed_zone() returns a non-zero value) after
> the memory has been onlined. This implies, that onlining memory will
> always free the added pages to the allocator immediately, but this is
> not true in all cases: when e.g. running as a Xen guest the onlined
> new memory will be added only to the ballooned memory list, it will be
> freed only when the guest is being ballooned up afterwards.
> 
> Another problem with using managed_zone() for the decision whether a
> zone is being added to the zonelists is, that a zone with all memory
> used will in fact be removed from all zonelists in case the zonelists
> happen to be rebuilt.
> 
> Use populated_zone() when building a zonelist as it has been done
> before that commit.
> 
> Cc: stable@vger.kernel.org

Some details, please.  Is this really serious enough to warrant
backporting?  Is some new workload/usage pattern causing people to hit
this?

