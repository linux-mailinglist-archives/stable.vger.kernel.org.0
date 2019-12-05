Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4791147B6
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 20:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbfLETe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 14:34:27 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:41807 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729816AbfLETe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 14:34:27 -0500
Received: by mail-qv1-f68.google.com with SMTP id b18so1741408qvo.8
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 11:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=ohFqpgFuVLwMR/fPnOxHSbjoD2kJwKsGI28iIy8iuZU=;
        b=FSI80S6wt6yqxmdtp9lMdXY3+LYc5UjWTB1vwIsAcXlDyfxSVPz5KQmZN0tZnN/TOT
         vq+PrzHxbrYch3Ux1DjOFE+WkZhecLq4WqrwcV1hXe77TNihVXGM+WSvhZiQ4XeAzhcM
         2zxZxrAE5+Z+XZFziJdXvGBOF7Aw4I2J6ZuLjXQuYIrz/puUMzv4ZIXy0PyiXC2QD1E9
         SGb04g64wzP+imIpkiiDEEOMPvFz24AmgKEuyXdEuklQ0Nt93OH9tdvw88ZoI7JjHISQ
         sD7+bJGg9ya8lxY9ezPzx/X04/x/puxZpNsXs65yfg7uzCy4dbwb220wBVTJmH6CNWAe
         gmXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=ohFqpgFuVLwMR/fPnOxHSbjoD2kJwKsGI28iIy8iuZU=;
        b=dD6nY/v1b/lPC5LAFbnQjn8Mm+G3fSlBaPzCSsO5dubsTbBvJFthXVeq2BLUgvmJHY
         6SZc3+oV6uiGZ4n+1xQLofuUIlgxbmhZj5mDHtj/3xv1hmx2M0DX+GiPOrG5jRAN8gEu
         WBZfgWosZ2vkMkegEd5dCpLtouTeSMZAzDV6pXW58e4AFlZNPynVizLwkRVbxobOL49T
         AAAxIizukxcMshK+4KB/E5ZBxI0enx/i4CysNHp4dw4a5p/9dcNmQ+1e0p4CXQ4CGdAB
         /CdLlZPFBBrBSukV8PT2t3Vs9ABGCI9z4A0jYLCyfJQAamIbYcOObSs3W9GIeFsl+l4V
         +myg==
X-Gm-Message-State: APjAAAV4cphevgGmIvPhgVzgvnpYGrUi4Z5SuHVpoHyp/P9iNIQje8VP
        6lCIjU3keMB6cD+ujpPn/E0wFy+ONsRmNQ==
X-Google-Smtp-Source: APXvYqykYO+fEIijGOKaoHOo0rjkpKIgKBKPXv5S5alIm7Mz3Z279D2irvJWzPaCU8jHSyK8jDXfFQ==
X-Received: by 2002:a05:6214:245:: with SMTP id k5mr9171653qvt.182.1575574466035;
        Thu, 05 Dec 2019 11:34:26 -0800 (PST)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id u24sm5362334qkm.40.2019.12.05.11.34.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 11:34:25 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if the page is already on the target node
Date:   Thu, 5 Dec 2019 14:34:24 -0500
Message-Id: <A5A53ED8-D17C-4BCD-9832-93DB0D9302A0@lca.pw>
References: <d96e3849-5fd4-26c0-31cf-02523085ed37@linux.alibaba.com>
Cc:     fabecassis@nvidia.com, jhubbard@nvidia.com, mhocko@suse.com,
        cl@linux.com, vbabka@suse.cz, mgorman@techsingularity.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <d96e3849-5fd4-26c0-31cf-02523085ed37@linux.alibaba.com>
To:     Yang Shi <yang.shi@linux.alibaba.com>
X-Mailer: iPhone Mail (17B111)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Dec 5, 2019, at 2:27 PM, Yang Shi <yang.shi@linux.alibaba.com> wrote:
>=20
> John noticed another return value inconsistency between the implementation=
 and the manpage. The manpage says it should return -ENOENT if the page is a=
lready on the target node, but it doesn't. It looks the original code didn't=
 return -ENOENT either, I'm not sure if this is a document issue or not. Any=
way this is another issue, once we confirm it we can fix it later.

No, I think it is important to figure out this in the first place. Otherwise=
, it is pointless to touch this piece of code over and over again, i.e., thi=
s is not another issue but the core of this problem on hand.=
