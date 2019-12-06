Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC6A114A2B
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 01:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfLFATh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 19:19:37 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46743 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfLFATh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 19:19:37 -0500
Received: by mail-qk1-f194.google.com with SMTP id f5so4972114qkm.13
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 16:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=X5BKMDzhk9He6AKioqZn9xv6gd84tSO5DFO6xwMevYw=;
        b=IUAwBVG9f6xINWXkadLp/j/jGbF/ANfoSF5zsqFLLy+AU1UlJCfRoRBOV7SJHs+dAv
         f8q6V0G7bNoJxnZHoA24ySqhT0OUWno5vkNaOv3uvp3sUnz8MBtb+gk5hlz/jN2RWAfV
         EITcumIBCswQfF99cv1YWBjwU334N2mUhl3o+WlxlN/839LS22tfvWElD1xQ3p5LAjkw
         DlPUe9Ujy9r1lECzPLYQ92cfwynapmsImU5ATMzbsQvKD2UxCSCe6hIDYxFdymymGb6r
         owoIhLdVxxQIlhAqVP7pS5nJ046IPuHfQbrXz/SW6b42gOKhqHg+xtqmyhlvchUJovkW
         WJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=X5BKMDzhk9He6AKioqZn9xv6gd84tSO5DFO6xwMevYw=;
        b=EcX0WgTMPQXyYRmIuu4AI1GEkyQVFdNM/dk8X+Lfd8OE8Bw79pRRG3uraRfyhlmOck
         O3WiVf19sOlDzFOaE2qfO6km0lzVCKheFl67EaAh9IWk0SQqvTOa9IlPP5jR7Jcztl9O
         Y8HFIGfsgxNeahxtSWJiTtd70tKPnFWfGjNDJjVbgd5ReHH4uMnwdvG37exMmcuHwwzJ
         QuItq+oy9j3MHMQ6vZv0e0sfNV5fDICoAAI0WS3x/in0EbvnC+jrvaOB1taf5gQ/RRK9
         uB4fQjJ4MujDim81qCN6jTCcnjmpmsb6MYvIpQA6i6Wb3gsb+xwd7O0Lo5LTllcIPMkg
         17Iw==
X-Gm-Message-State: APjAAAWuU6qJu2a/twS4zmrzWM6IPzcawR13JygE/bfzxWd6P0lOXOTo
        cnEtUClsntbQhA3C2BRa9I13s9KSbo0=
X-Google-Smtp-Source: APXvYqyKOaKqD4naAnIv6vb0dV+7aph7vWmbuMsUb65qWebhgIw/D0smIg8+d1WU3nRWNxhsfUckdQ==
X-Received: by 2002:a37:4b06:: with SMTP id y6mr4646884qka.14.1575591575819;
        Thu, 05 Dec 2019 16:19:35 -0800 (PST)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id 62sm5327116qkk.102.2019.12.05.16.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 16:19:35 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if the page is already on the target node
Date:   Thu, 5 Dec 2019 19:19:34 -0500
Message-Id: <D0A99204-A60F-428E-B77A-63DBCD7103F4@lca.pw>
References: <22b5bfde-45be-95bd-5c98-2ab13302c107@nvidia.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>, fabecassis@nvidia.com,
        mhocko@suse.com, cl@linux.com, vbabka@suse.cz,
        mgorman@techsingularity.net, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
In-Reply-To: <22b5bfde-45be-95bd-5c98-2ab13302c107@nvidia.com>
To:     John Hubbard <jhubbard@nvidia.com>
X-Mailer: iPhone Mail (17B111)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Dec 5, 2019, at 7:04 PM, John Hubbard <jhubbard@nvidia.com> wrote:
>=20
> Felix's code is not random test code. It's code he wrote and he expected i=
t to work.

Sure, but could he show a bit detail if the kernel will start to behavior as=
 expected like what was written in the manpage to return ENOENT in this case=
, why is it not acceptable? i.e., why is it important to depend on the broke=
n behavior?=
