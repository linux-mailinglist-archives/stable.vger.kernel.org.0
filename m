Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40041199934
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 17:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730615AbgCaPHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 11:07:50 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:38885 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730528AbgCaPHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 11:07:50 -0400
Received: by mail-ua1-f68.google.com with SMTP id g10so1933873uae.5
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 08:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VEnIRN7gs5winkgBmG4qJkOevSACutGdIkW1fdG63F8=;
        b=at0tpdqyNOMKLLAgdbB721uamkoaTjrVaOtlLjFfCFpU6/eJ3EwNFb2dYeWDbvgAyP
         ERsJXqZtpvKqpoyEWKoItRKTohB8NwYPOdu9ATwKiOWcCpxFQlkKDy4j56bXm5xuxw4I
         3S6f4xEMXBlPuomTDSquQ7pco1n0xXPkvn0cezogPBkhZ0uGbgtCpVvizGlNgYp+zEYo
         mAnUCNKN6VRhDbqDojBXYczPt5SlI6DcxjTK53vP7PI+L30owlq6aZmveV+sUJhZYRdq
         D89w+IXm76aAIOf/JZH0bu0RHJMD+Gixh+oQroTuukO+LjJYgLb0c6syR26TLOn1zSLJ
         9RVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VEnIRN7gs5winkgBmG4qJkOevSACutGdIkW1fdG63F8=;
        b=k4tUvJ8N1imFH9hq7kcySfOJ1rTA9gQ1snSmIFUhSAsQcfzMld5ZPqWBzPvR5b022b
         kMv5ub8s2cNq4qHCkd9zDbraq3Tai5yfssm0OuApV/TRjK91p+mGmKLRidwcTGGTrWIF
         t+AGSYthkuz/rdHWYMEO7wcAxsD6VHzXyDOKQmF/tVbeTIeOMbzg1JlJN1vVVr483g/Q
         kXVeZOeWCyGShVBCT36rXHkbpEdg18HQhnSdZMpKyz3bLr1qPkNMChtaIPFJbCZSuUyF
         PIjvWLaBGkosRDBCZIcdEiRaO2oonWVmiExrKQkhjERglUNdz523ZPgEHJYZ9JBSwYu+
         M9+A==
X-Gm-Message-State: AGi0Pub3qw0P0gjww5ElhcAhGsWD+yUtbDSnedi4RfjzXOFu8vmlj97b
        uWV66U6kbr6JfMxCMTshRLdDOlyCtkhTtm8vT7Y=
X-Google-Smtp-Source: APiQypLIBkM7sUv/g3FHK9Oj6OA0PuadczzwZDyh5gsNmWlTHJ3APUj0tNFmtEb3FoYLBjHDquAEVL7zpJUkXi6Dymo=
X-Received: by 2002:ab0:2085:: with SMTP id r5mr12497147uak.95.1585667269071;
 Tue, 31 Mar 2020 08:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200331124202.4497-1-chris@chris-wilson.co.uk>
In-Reply-To: <20200331124202.4497-1-chris@chris-wilson.co.uk>
From:   Matthew Auld <matthew.william.auld@gmail.com>
Date:   Tue, 31 Mar 2020 16:07:21 +0100
Message-ID: <CAM0jSHPOY4So442J1O0zW75cBwM4rCPm1CN0YVOMLMJhU=uhfw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Fill all the unused space in the GGTT
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Matthew Auld <matthew.auld@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 31 Mar 2020 at 13:42, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> When we allocate space in the GGTT we may have to allocate a larger
> region than will be populated by the object to accommodate fencing. Make
> sure that this space beyond the end of the buffer points safely into
> scratch space, in case the HW tries to access it anyway (e.g. fenced
> access to the last tile row).
>
> Reported-by: Imre Deak <imre.deak@intel.com>
> References: https://gitlab.freedesktop.org/drm/intel/-/issues/1554
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Matthew Auld <matthew.auld@intel.com>
> Cc: Imre Deak <imre.deak@intel.com>
> Cc: stable@vger.kernel.org

Do we not need similar treatment for gen6? It seems to also play
tricks with the nop clear range, or did we disable gen7 ppgtt in the
end?

Reviewed-by: Matthew Auld <matthew.auld@intel.com>
