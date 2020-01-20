Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2EB3142BF3
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 14:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgATNRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 08:17:48 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39209 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgATNRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 08:17:48 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so29525286wrt.6;
        Mon, 20 Jan 2020 05:17:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Hg8lEj6IfSDi5BHq/iEw/j7YLmN0NQVwuEmhkiLJ3Jc=;
        b=kzFFB8DKQU5dar1S8h+QNUVTgXs7ctPMEnIbv9UdAnWnOfJn4uKU6xQffI+Px12XfZ
         Bjui103auC4T7+rXOLQmifpZtceAHN1FNyOBqPNELItRFEtkJSj+qPYuQi43Qtpg2JoN
         7+qxeA50TF+wsKaDwmU7hWC9SuTROglTWirpRbs3F2t214UXQqwnVolRlB0kqm2xMwVz
         AdK8ixYCn4yVI4o+RqBp8bAQvlzNKDWcy5XtCGQKRurduLmXtRIXkFdNC2NrOk8ko8d3
         kBGkQebZxAYGP0ro8TCNMVXwHT4Mw82YQOZjUbABV3olYdeyOJdT6BPX55N2TDf1K8rM
         mROA==
X-Gm-Message-State: APjAAAWtYxA/85umLe/4Ybn9D5s8iTzoJ8plhd6dkPna/2oD6GJgnTd2
        UH5GgDDCuls8ONDFaIBsWsj8nlRE
X-Google-Smtp-Source: APXvYqyVfB1hBEBbz7ctRSgXmXP0aTRxz7DuVUW+KSpWwK5HyHTKJKUeZtYsWDLXBPs4ghfkmDelrg==
X-Received: by 2002:a5d:4392:: with SMTP id i18mr18272968wrq.199.1579526265911;
        Mon, 20 Jan 2020 05:17:45 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id t131sm24423327wmb.13.2020.01.20.05.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:17:45 -0800 (PST)
Date:   Mon, 20 Jan 2020 14:17:44 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     richardw.yang@linux.intel.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: move_pages: fix the return value if there are
 not-migrated pages
Message-ID: <20200120131744.GE18451@dhcp22.suse.cz>
References: <1579325203-16405-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200120130624.GD18451@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120130624.GD18451@dhcp22.suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 20-01-20 14:06:26, Michal Hocko wrote:
> On Sat 18-01-20 13:26:43, Yang Shi wrote:
> > The do_move_pages_to_node() might return > 0 value, the number of pages
> > that are not migrated, then the value will be returned to userspace
> > directly.  But, move_pages() syscall would just return 0 or errno.  So,
> > we need reset the return value to 0 for such case as what pre-v4.17 did.
> 
> The patch is wrong. migrate_pages returns the number of pages it
> _hasn't_ migrated or -errno. Yeah that semantic sucks but...
> So err != 0 is always an error. Except err > 0 doesn't really provide
> any useful information to the userspace. I cannot really remember what
> was the actual behavior before my rework because there were some gotchas
> hidden there.

OK, so I've double checked. do_move_page_to_node_array would carry the
error code over to do_pages_move and it would store the status stored
in the pm array. It contains page_to_nid(page) so the resulting code
indeed behaves properly before my change and this is a regression. I
have a very vague recollection that this has been brought up already.
<...looks in notes...>
Found it! The report is
http://lkml.kernel.org/r/0329efa0984b9b0252ef166abb4498c0795fab36.1535113317.git.jstancek@redhat.com
and my proposed workaround was http://lkml.kernel.org/r/20180829145537.GZ10223@dhcp22.suse.cz

> If you want to fix this properly then you have to query node status of
> each page unmigrated when migrate_pages fails with > 0. This would be
> easier if the fix is done on the latest cleanup posted to the list which
> consolidates all do_move_pages_to_node and store_status calls to a
> single function.

Sorry forgot to put a reference to the patch: http://lkml.kernel.org/r/20200119030636.11899-5-richardw.yang@linux.intel.com

-- 
Michal Hocko
SUSE Labs
