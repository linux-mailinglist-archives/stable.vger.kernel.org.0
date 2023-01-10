Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B783664A61
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239319AbjAJSco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239372AbjAJScL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:32:11 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801355B4A1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:27:16 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id e13so13498507ljn.0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ShU3lDY6GJI8ggbz9GikiyJz3+sZxpSyvZWgc9tJAwk=;
        b=ybAbiblUQPAF0VdFc+1XKh3mBUCtjfMA2Q/3lE3YbIJBAZXm8RbKZJZC7hHlUoHnH4
         w3Mdnk7CTO/zXp7cpQ4TTx8A+Vdwu7rTYgeQ0f8qWmcMemC6m22fMLhQzQZg8pCgYyE6
         RRlGp0P1j2p9KOcBkFTC/H4meA42m8twO1O3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ShU3lDY6GJI8ggbz9GikiyJz3+sZxpSyvZWgc9tJAwk=;
        b=qyPRyfIn5bOhmfuVESeVsyUBYbSbZo3TBm2p6ve/YEHmeuMLvp2wPJLj3cU9dUSoR6
         8XZnPXmmkb5TMBRUGfRX7kYODucCG2WI2nSoFs3+AGCF3CdOc3u1ZRLOgB18FlnWmjvk
         um4RzUy0BUKmANCorGXTFepLxGZOCFt4DFEc/jNcqm05+Ky48VbKro+SgqoztJHIsY7U
         s2oQ6rqyqSbH1lu6oSSHrIuE8aMvTYt+0fczYIm5YlmwFPAe0LGo76HE5VaCCvX67vVh
         OV8vCMCZyYTJxuG77MZKyFzvAGlzBYSL4b9n3xS9ktQJnA4OsVhYDQ6qPvdhBFuq256k
         4SzA==
X-Gm-Message-State: AFqh2krp+9nlVBmmiOzSIgJsS/lS9ws4jzbBUj2l0FcHFO/CAAH8pjbj
        LUZAMc6mAeS0OK4bUCOppBMWqSmv7TFnxWWft5I6Tw==
X-Google-Smtp-Source: AMrXdXt/W4AlREqzhFnGF9afSPt07wXNzsyNaFjWN07K7Haos9cvue5bZfKDEKNEzr9ityRbRBH6lLdr6w7YF9p5+S0=
X-Received: by 2002:a2e:3215:0:b0:27f:b98c:7a0e with SMTP id
 y21-20020a2e3215000000b0027fb98c7a0emr4688452ljy.356.1673375234806; Tue, 10
 Jan 2023 10:27:14 -0800 (PST)
MIME-Version: 1.0
References: <20230110180031.620810905@linuxfoundation.org> <20230110180033.597780936@linuxfoundation.org>
 <CAEXW_YQhoJkCNaBKRSLh5OCYn1ObA8dy63ZrgmRgpEaVorBnnQ@mail.gmail.com>
In-Reply-To: <CAEXW_YQhoJkCNaBKRSLh5OCYn1ObA8dy63ZrgmRgpEaVorBnnQ@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Tue, 10 Jan 2023 13:27:02 -0500
Message-ID: <CAEXW_YQeDCfP-2cJ5Qwx5gAiPxzn4uTEqKB6m3BsCwzpM43qAA@mail.gmail.com>
Subject: Re: [PATCH 5.15 057/290] rcu-tasks: Simplify trc_read_check_handler()
 atomic operations
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        "Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 1:26 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Tue, Jan 10, 2023 at 1:23 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Paul E. McKenney <paulmck@kernel.org>
> >
> > commit 96017bf9039763a2e02dcc6adaa18592cd73a39d upstream.
>
> Thanks Greg, I had sent the same patch earlier for 5.15. Just so I
> learn, anything I did wrong or should have done differently?

Never mind, I think it is just coming from your queue after you picked
mine up...
