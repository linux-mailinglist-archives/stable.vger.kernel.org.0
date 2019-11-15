Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4ACAFE451
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 18:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfKORss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 12:48:48 -0500
Received: from mail-qv1-f53.google.com ([209.85.219.53]:44857 "EHLO
        mail-qv1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfKORss (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 12:48:48 -0500
Received: by mail-qv1-f53.google.com with SMTP id d3so4078334qvs.11;
        Fri, 15 Nov 2019 09:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Tggz0Sup0tJF7r/miqRqPkt8QctjM6InW2y0Q0myCrA=;
        b=YRwOG6FnZpiAU/ObEKfFoLeH/BCO4X7fGLIUL0/xug+uGlbhVwQmRJuMAs4JwqSmdZ
         BBBEcHVid4mj6iyuE2y9bFo3+ursRhOY8/ugAfoZFQOoTb8BU2o41wtkDGZRfiXZTPS/
         5rFKFXg/Hq4c9Vbva7CFLkNwlT4AP/YwWMy+6RKbbruhfMkZTxjjQU7lMB2MIzdEEqZC
         kFoApnlFJS+sKduvaKlGXvm/TzT3TC4W6Pyryv8bXo+kOCLHqkOz7mDgBfRofD4ICoaD
         /bx/hfTcEsEURtRGNZVn3tUY9m193AYhL5Jea7wkggKhwjlM3APZflaFfE9HJXCM6D0B
         m94A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Tggz0Sup0tJF7r/miqRqPkt8QctjM6InW2y0Q0myCrA=;
        b=WEgISatshGoj4JR6Xu4Y57uolSISy6nVdxuUapaC5pLUbbSh0UDMOqnrkAddHCzb3E
         DuZ8zJIem3v+hVn3K9OikqdHzuNHj5LBExaXMDZTsgCjslNDeCUvJORD8c+3J2naD195
         EFzze6fnkoFrTf5FHEY/E1doeiyEdXIxa8FWmVq1SV/6zKCtrJUW+PxRdwLeFfYWFtqQ
         Zea2dnrOZlre/CwKuK98/DijUn6MiOhyF0bVOSlrtZ2iBhmZayInqxDBHZkl8YpubguX
         1IEl5Q1yDV+B1fo9XViaoyzWy/6t+JVaP+qlg/AY1PswCtC24cSgpjTKIV0RI2bDbMxE
         Q6pA==
X-Gm-Message-State: APjAAAXUCblhF6NU4X7SlSwLDpLTGkuoFllE50Sj3uebkgsR/VGZFyTY
        zCHTGhTtCm26oiWQXzUG2T8=
X-Google-Smtp-Source: APXvYqydPSTYxYN82kZIJOLGlcFhkq+6JEEBk7LqqlPn79KmDLe7cS/rHfO/ZD0Ur8OF3MNkOiR1lA==
X-Received: by 2002:ad4:458b:: with SMTP id x11mr7704350qvu.7.1573840127172;
        Fri, 15 Nov 2019 09:48:47 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::4ef1])
        by smtp.gmail.com with ESMTPSA id 76sm4642961qke.111.2019.11.15.09.48.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 09:48:46 -0800 (PST)
Date:   Fri, 15 Nov 2019 09:48:44 -0800
From:   Tejun Heo <tj@kernel.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Roman Gushchin <guro@fb.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Message-ID: <20191115174844.GR4163745@devbig004.ftw2.facebook.com>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191113162934.GF19372@blackbody.suse.cz>
 <20191113170823.GA12464@castle.DHCP.thefacebook.com>
 <20191114191657.GN20866@dhcp22.suse.cz>
 <20191114192018.GJ4163745@devbig004.ftw2.facebook.com>
 <20191114193340.GA24848@dhcp22.suse.cz>
 <20191114193736.GL4163745@devbig004.ftw2.facebook.com>
 <20191115174031.GA15216@dhcp22.suse.cz>
 <20191115174721.GB15216@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115174721.GB15216@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 15, 2019 at 06:47:21PM +0100, Michal Hocko wrote:
> s@online@offline@
> 
> And reading after myself it turned out to sound differently than I
> meant. What I wanted to say really is, what is the difference that
> css_tryget_online really guarantee when the css might go offline right
> after the call suceeds so more specifically what is the difference
> between
> 	if (css_tryget()) {
> 		if (online)
> 			DO_SOMETHING
> 	}
> and
> 	if (css_tryget_online()) {
> 		DO_SOMETHING
> 	}
> 
> both of them are racy and do not provide any guarantee wrt. online
> state.

It's about not giving new reference when the object is known to be
delted to the user.  Can you please think more about how file
deletions work?

Thanks.

-- 
tejun
