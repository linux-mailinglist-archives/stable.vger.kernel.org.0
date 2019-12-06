Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E56114CAA
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 08:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfLFHfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 02:35:20 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50779 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfLFHfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 02:35:19 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so6747372wmg.0;
        Thu, 05 Dec 2019 23:35:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TyEnM0ErjIPbJfUas4Rc8uwAWuUH9XQEwJswELT2XBM=;
        b=a+kFwJP5liSG2np4IwwwWU2lewCtu4zvfDm/JS5H+b3V7A3axjM6rMfv4oJvf2VIDp
         NMM+nb8Ml3KTFCmUnTYLrJORy7BpXKBTd58yjGWrZJlFuVUCDZiuh6T5EyxZyCDCur5h
         mBpit7jrodl8vYrESeaIjxviC0PwIi2Gts7bMSkjfcMArn96eihs8vNCYwfvSBKYTzl8
         tpHnXO1uOyQd6j1FVmlcYgthwfhUQqna7pJ7S8p/nP26JD5Pds90iAFYjqOjbS0Ptxvt
         DQiaI0x4Up2kYiMJMIsl0vl84qts2L0+uUmiHkrcAfn2qBA+kaaXY27QDz7EVM1MQ8He
         ASKA==
X-Gm-Message-State: APjAAAUE2LaqxGmJ5c7GWHSWB01dtPrNkdgrqDgQIxtJAKr8s5FXsup2
        /A4FNmB3CwWFZOeNYPsmYamGO0Le
X-Google-Smtp-Source: APXvYqxMqJTdvmC8VrePF92jfpjNcRNRLwDaMoMIKM7+yrkmKV6C3nq+6QCBgOmZOdQ9wtQlW3Sf5Q==
X-Received: by 2002:a1c:7914:: with SMTP id l20mr8727185wme.38.1575617717668;
        Thu, 05 Dec 2019 23:35:17 -0800 (PST)
Received: from localhost (ip-37-188-170-11.eurotel.cz. [37.188.170.11])
        by smtp.gmail.com with ESMTPSA id e19sm2488431wme.6.2019.12.05.23.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 23:35:16 -0800 (PST)
Date:   Fri, 6 Dec 2019 08:35:15 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Christopher Lameter <cl@linux.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>, fabecassis@nvidia.com,
        jhubbard@nvidia.com, vbabka@suse.cz, mgorman@techsingularity.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
Message-ID: <20191206073515.GH28317@dhcp22.suse.cz>
References: <1575572053-128363-1-git-send-email-yang.shi@linux.alibaba.com>
 <alpine.DEB.2.21.1912051944030.10280@www.lameter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1912051944030.10280@www.lameter.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 05-12-19 19:45:49, Cristopher Lameter wrote:
> On Fri, 6 Dec 2019, Yang Shi wrote:
> 
> > Felix Abecassis reports move_pages() would return random status if the
> > pages are already on the target node by the below test program:
> 
> Looks ok.
> 
> Acked-by: Christoph Lameter <cl@linux.com>
> 
> Nitpicks:
> 
> > @@ -1553,7 +1555,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
> >  	if (PageHuge(page)) {
> >  		if (PageHead(page)) {
> >  			isolate_huge_page(page, pagelist);
> > -			err = 0;
> > +			err = 1;
> 
> Add a meaningful constant instead of 1?

Well 1 has a good meaning here actually. We have -errno or the number of
queued pages.

-- 
Michal Hocko
SUSE Labs
