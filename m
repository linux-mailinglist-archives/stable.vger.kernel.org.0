Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255CD4EC94E
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 18:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348601AbiC3QKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 12:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348621AbiC3QKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 12:10:00 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7381EC76
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 09:08:12 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h4so17232414edr.3
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 09:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sweetwater-ai.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hYdb8v25EBrRCJun0B+wT+nPNFmtXEWQPC9xovEDcFY=;
        b=Y/ApIynYjwFwmNm/B7Gb5h0sxkT1lKhYQY8SLODKDMqj8W0Caq6SYTzzEAiOg66Hp7
         wxQ91wLAuTARTk2zT0ZHUbA495QxsKpp2t+RPfcxtBSK/imOMF9PArXZW182juARCbO4
         PVAZE7ao8ptxyhc/hEtuqUwSZBWv3po7ThRDawhAt06+VNCYk0ZVTQZs255SLsTJM69G
         1dzRKi08bxlfP0EZuUlNcs6Yrkz+ZJiFv3225fREUT8xRr1ky6fW/W/rZQir4AKTWGKA
         8m9gHB9hf6WDwgl3itXFlLSP5QIF98XhkxVph1N0WITyo/FcJ2NXPT15UYxsoeL30mE7
         UaYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hYdb8v25EBrRCJun0B+wT+nPNFmtXEWQPC9xovEDcFY=;
        b=uzPi2JbVsAjdX69Vnl7BpBYyTLAdcn7c0GkTI/U8zY3iki5jZls/OEK+APF3DYy0Z/
         ZAohFly7y2I/+GQqDaRdHttVdXx5P/MoFxmy4wB8EQeCfkowsyC2TgSLnKfBWpne1IOP
         gtKqLgddVMMrQx4ASr7ZVxEZX047/nImxmDjz9j7T1Zm/B3wx5BD+1dUN0U1aG/Ron79
         dgA+x90RDpadKKWcYqf+BmVJZQtlDSEd+Y63FcJzWonVzz8nR8UMA3EhcNDPhQFC+f+O
         vZgKwLrPUX6b0/OSWFu2U/BvQYBcPj06ziZnA+u7cau+b1bBWs2Ucj01R2I1jXOIG2zy
         dSZg==
X-Gm-Message-State: AOAM530uddNkg1g1zkx+ZuOQM+LKy0Cpu7J3XcOvdibophrYIASR5yPV
        Pov5Bh7i8jMdh7PWiH7k5/QDTnXGyarmMDMLnIJftg==
X-Google-Smtp-Source: ABdhPJyYcNTmbRT1tcd6xuAK2aXe9nzYXsom9HnXPvbB4WR+xejfSPQplVhWu710d4MwLNE0k/m114sWaBm97cT9sH0=
X-Received: by 2002:a05:6402:27c7:b0:41b:51ca:f542 with SMTP id
 c7-20020a05640227c700b0041b51caf542mr10459564ede.149.1648656491009; Wed, 30
 Mar 2022 09:08:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220328111828.1554086-1-sashal@kernel.org> <20220328111828.1554086-16-sashal@kernel.org>
In-Reply-To: <20220328111828.1554086-16-sashal@kernel.org>
From:   Michael Brooks <m@sweetwater.ai>
Date:   Wed, 30 Mar 2022 09:08:02 -0700
Message-ID: <CAOnCY6TTx65+Z7bBwgmd8ogrCH78pps59u3_PEbq0fUpd1n_6A@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.17 16/43] random: use computational hash for
 entropy extraction
To:     Sasha Levin <sashal@kernel.org>
Cc:     Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I think I understand the bug that Jason is referring to, but really he
is referring to the tip of a larger issue - and correct me if I am
wrong.

Let=E2=80=99s say an attacker is a user resident on the machine and can
internally drain the pool via `cat /dev/urandom > /dev/null` - this
will take the high quality random sources and throw it away - forcing
the kernel to use the degraded try_to_generate_entropy() method.

In this state, the kernel performance will be affected, this is a
moderate DoS attack - it won=E2=80=99t bring the system down, but you are
going to have a bad time.  What is serious is the state of the pool -
what happens is that the ratio of =E2=80=9Cgood=E2=80=9D to =E2=80=9Cbad=E2=
=80=9D entropy sources
becomes more and more undesirable.  Sure,  mixing jiffies will fool
die-harder, but that=E2=80=99s easy to do.  There is a deeper issue here th=
at
die-harder cannot test for - and that is a more intentional parallel
construction.  Die-Harder is attempting a parallel construction
without knowing how the RNG is designed.

It is safe to assume that a user who is resident on the machine not
only has a wrist watch, but also can query jiffies directly, this is
not a hidden value.  Now, this codebase seems to use that word
=E2=80=9Centropy=E2=80=9D a whole lot, and entropy is a physics term. In ph=
ysical
space - entropy has a lot of emptiness that expands over time, and
also contains known values - these attributes do not aid in the
creation of a secure /dev/random device driver.  Sure Jiffies provides
entropy, but it is a bit like pointing at the moon because it is a
value that everyone can see, and is even something that a remote
attacker could determine using something similar to a vector clock.
The physics definition of =E2=80=9Centropy=E2=80=9D is simply not useful fo=
r our
needs.  What we really need is to collect as many =E2=80=9Cunknown values=
=E2=80=9D as
we can.

I=E2=80=99d like to describe this bug using mathematics, because that is ho=
w I
work - I am the kind of person that appreciates rigor.  In this case,
let's use inductive reasoning to illuminate this issue.

Now, in this attack scenario let =E2=80=9Cp=E2=80=9D be the overall pool st=
ate and let
=E2=80=9Cn=E2=80=9D be the good unknown values added to the pool.  Finally,=
 let =E2=80=9Ck=E2=80=9D be
the known values - such as jiffies.  If we then describe the ratio of
unknown uniqueness with known uniqueness as p=3Dn/k then as a k grows
the overall predictability of the pool approaches an infinite value as
k approaches zero.   A parallel pool, let's call it p=E2=80=99 (that is
pronounced =E2=80=9Cp-prime=E2=80=9D for those who don=E2=80=99t get the no=
tation).  let
p=E2=80=99=3Dn=E2=80=99/k=E2=80=99. In this case the attacker has no hope o=
f constructing n=E2=80=99,
but they can construct k=E2=80=99 - therefore the attacker=E2=80=99s paraso=
l model of
the pool p=E2=80=99 will become more accurate as the attack persists leadin=
g
to p=E2=80=99 =3D p as time->=E2=88=9E.

Q.E.D.

In summation, it=E2=80=99s not entropy that we are after  and mix_pool_byte=
s()
does not impact the ratio above. What we are really after is =E2=80=98hidde=
n
uniqueness=E2=80=99.  We need unique values that are not known to any would=
-be
attacker, and the more uncertainty we can add to our pool the harder
it will be for an outsider to reconstruct the internal state - which
is why find_unqinees_in_memeory() is valuable.

There is a way to solve the predictability of the internal pool
without melting the ice caps - and =E2=80=9Cjumptable=E2=80=9D and =E2=80=
=9Cgatekey=E2=80=9D does this
by allowing access to the pool without revealing ANY internal
structure. Furthermore if we are using an ideal block cipher or hash
function in our csprng then these primitives do a great job at
obscuring the pre-image because that is what they were built for.

TLDR; this ain't good - yes, Jason is right that the branch is
currently vulnerable. So should we roll out this code? Or should we do
it right?

-Michael Brooks


On Mon, Mar 28, 2022 at 4:20 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
>
> [ Upstream commit 6e8ec2552c7d13991148e551e3325a624d73fac6 ]
>
> The current 4096-bit LFSR used for entropy collection had a few
> desirable attributes for the context in which it was created. For
> example, the state was huge, which meant that /dev/random would be able
> to output quite a bit of accumulated entropy before blocking. It was
> also, in its time, quite fast at accumulating entropy byte-by-byte,
> which matters given the varying contexts in which mix_pool_bytes() is
> called. And its diffusion was relatively high, which meant that changes
> would ripple across several words of state rather quickly.
>
> However, it also suffers from a few security vulnerabilities. In
> particular, inputs learned by an attacker can be undone, but moreover,
> if the state of the pool leaks, its contents can be controlled and
> entirely zeroed out. I've demonstrated this attack with this SMT2
> script, <https://xn--4db.cc/5o9xO8pb>, which Boolector/CaDiCal solves in
> a matter of seconds on a single core of my laptop, resulting in little
> proof of concept C demonstrators such as <https://xn--4db.cc/jCkvvIaH/c>.
>
> For basically all recent formal models of RNGs, these attacks represent
> a significant cryptographic flaw. But how does this manifest
> practically? If an attacker has access to the system to such a degree
> that he can learn the internal state of the RNG, arguably there are
> other lower hanging vulnerabilities -- side-channel, infoleak, or
> otherwise -- that might have higher priority. On the other hand, seed
> files are frequently used on systems that have a hard time generating
> much entropy on their own, and these seed files, being files, often leak
> or are duplicated and distributed accidentally, or are even seeded over
> the Internet intentionally, where their contents might be recorded or
> tampered with. Seen this way, an otherwise quasi-implausible
> vulnerability is a bit more practical than initially thought.
>
> Another aspect of the current mix_pool_bytes() function is that, while
> its performance was arguably competitive for the time in which it was
> created, it's no longer considered so. This patch improves performance
> significantly: on a high-end CPU, an i7-11850H, it improves performance
> of mix_pool_bytes() by 225%, and on a low-end CPU, a Cortex-A7, it
> improves performance by 103%.
>
> This commit replaces the LFSR of mix_pool_bytes() with a straight-
> forward cryptographic hash function, BLAKE2s, which is already in use
> for pool extraction. Universal hashing with a secret seed was considered
> too, something along the lines of <https://eprint.iacr.org/2013/338>,
> but the requirement for a secret seed makes for a chicken & egg problem.
> Instead we go with a formally proven scheme using a computational hash
> function, described in sections 5.1, 6.4, and B.1.8 of
> <https://eprint.iacr.org/2019/198>.
>
> BLAKE2s outputs 256 bits, which should give us an appropriate amount of
> min-entropy accumulation, and a wide enough margin of collision
> resistance against active attacks. mix_pool_bytes() becomes a simple
> call to blake2s_update(), for accumulation, while the extraction step
> becomes a blake2s_final() to generate a seed, with which we can then do
> a HKDF-like or BLAKE2X-like expansion, the first part of which we fold
> back as an init key for subsequent blake2s_update()s, and the rest we
> produce to the caller. This then is provided to our CRNG like usual. In
> that expansion step, we make opportunistic use of 32 bytes of RDRAND
> output, just as before. We also always reseed the crng with 32 bytes,
> unconditionally, or not at all, rather than sometimes with 16 as before,
> as we don't win anything by limiting beyond the 16 byte threshold.
>
> Going for a hash function as an entropy collector is a conservative,
> proven approach. The result of all this is a much simpler and much less
> bespoke construction than what's there now, which not only plugs a
> vulnerability but also improves performance considerably.
>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/char/random.c | 304 ++++++++----------------------------------
>  1 file changed, 55 insertions(+), 249 deletions(-)
>
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 3404a91edf29..882f78829a24 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -42,61 +42,6 @@
>   */
>
>  /*
> - * (now, with legal B.S. out of the way.....)
> - *
> - * This routine gathers environmental noise from device drivers, etc.,
> - * and returns good random numbers, suitable for cryptographic use.
> - * Besides the obvious cryptographic uses, these numbers are also good
> - * for seeding TCP sequence numbers, and other places where it is
> - * desirable to have numbers which are not only random, but hard to
> - * predict by an attacker.
> - *
> - * Theory of operation
> - * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> - *
> - * Computers are very predictable devices.  Hence it is extremely hard
> - * to produce truly random numbers on a computer --- as opposed to
> - * pseudo-random numbers, which can easily generated by using a
> - * algorithm.  Unfortunately, it is very easy for attackers to guess
> - * the sequence of pseudo-random number generators, and for some
> - * applications this is not acceptable.  So instead, we must try to
> - * gather "environmental noise" from the computer's environment, which
> - * must be hard for outside attackers to observe, and use that to
> - * generate random numbers.  In a Unix environment, this is best done
> - * from inside the kernel.
> - *
> - * Sources of randomness from the environment include inter-keyboard
> - * timings, inter-interrupt timings from some interrupts, and other
> - * events which are both (a) non-deterministic and (b) hard for an
> - * outside observer to measure.  Randomness from these sources are
> - * added to an "entropy pool", which is mixed using a CRC-like function.
> - * This is not cryptographically strong, but it is adequate assuming
> - * the randomness is not chosen maliciously, and it is fast enough that
> - * the overhead of doing it on every interrupt is very reasonable.
> - * As random bytes are mixed into the entropy pool, the routines keep
> - * an *estimate* of how many bits of randomness have been stored into
> - * the random number generator's internal state.
> - *
> - * When random bytes are desired, they are obtained by taking the BLAKE2=
s
> - * hash of the contents of the "entropy pool".  The BLAKE2s hash avoids
> - * exposing the internal state of the entropy pool.  It is believed to
> - * be computationally infeasible to derive any useful information
> - * about the input of BLAKE2s from its output.  Even if it is possible t=
o
> - * analyze BLAKE2s in some clever way, as long as the amount of data
> - * returned from the generator is less than the inherent entropy in
> - * the pool, the output data is totally unpredictable.  For this
> - * reason, the routine decreases its internal estimate of how many
> - * bits of "true randomness" are contained in the entropy pool as it
> - * outputs random numbers.
> - *
> - * If this estimate goes to zero, the routine can still generate
> - * random numbers; however, an attacker may (at least in theory) be
> - * able to infer the future output of the generator from prior
> - * outputs.  This requires successful cryptanalysis of BLAKE2s, which is
> - * not believed to be feasible, but there is a remote possibility.
> - * Nonetheless, these numbers should be useful for the vast majority
> - * of purposes.
> - *
>   * Exported interfaces ---- output
>   * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>   *
> @@ -298,23 +243,6 @@
>   *
>   *     mknod /dev/random c 1 8
>   *     mknod /dev/urandom c 1 9
> - *
> - * Acknowledgements:
> - * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> - *
> - * Ideas for constructing this random number generator were derived
> - * from Pretty Good Privacy's random number generator, and from private
> - * discussions with Phil Karn.  Colin Plumb provided a faster random
> - * number generator, which speed up the mixing function of the entropy
> - * pool, taken from PGPfone.  Dale Worley has also contributed many
> - * useful ideas and suggestions to improve this driver.
> - *
> - * Any flaws in the design are solely my responsibility, and should
> - * not be attributed to the Phil, Colin, or any of authors of PGP.
> - *
> - * Further background information on this topic may be obtained from
> - * RFC 1750, "Randomness Recommendations for Security", by Donald
> - * Eastlake, Steve Crocker, and Jeff Schiller.
>   */
>
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> @@ -358,79 +286,15 @@
>
>  /* #define ADD_INTERRUPT_BENCH */
>
> -/*
> - * If the entropy count falls under this number of bits, then we
> - * should wake up processes which are selecting or polling on write
> - * access to /dev/random.
> - */
> -static int random_write_wakeup_bits =3D 28 * (1 << 5);
> -
> -/*
> - * Originally, we used a primitive polynomial of degree .poolwords
> - * over GF(2).  The taps for various sizes are defined below.  They
> - * were chosen to be evenly spaced except for the last tap, which is 1
> - * to get the twisting happening as fast as possible.
> - *
> - * For the purposes of better mixing, we use the CRC-32 polynomial as
> - * well to make a (modified) twisted Generalized Feedback Shift
> - * Register.  (See M. Matsumoto & Y. Kurita, 1992.  Twisted GFSR
> - * generators.  ACM Transactions on Modeling and Computer Simulation
> - * 2(3):179-194.  Also see M. Matsumoto & Y. Kurita, 1994.  Twisted
> - * GFSR generators II.  ACM Transactions on Modeling and Computer
> - * Simulation 4:254-266)
> - *
> - * Thanks to Colin Plumb for suggesting this.
> - *
> - * The mixing operation is much less sensitive than the output hash,
> - * where we use BLAKE2s.  All that we want of mixing operation is that
> - * it be a good non-cryptographic hash; i.e. it not produce collisions
> - * when fed "random" data of the sort we expect to see.  As long as
> - * the pool state differs for different inputs, we have preserved the
> - * input entropy and done a good job.  The fact that an intelligent
> - * attacker can construct inputs that will produce controlled
> - * alterations to the pool's state is not important because we don't
> - * consider such inputs to contribute any randomness.  The only
> - * property we need with respect to them is that the attacker can't
> - * increase his/her knowledge of the pool's state.  Since all
> - * additions are reversible (knowing the final state and the input,
> - * you can reconstruct the initial state), if an attacker has any
> - * uncertainty about the initial state, he/she can only shuffle that
> - * uncertainty about, but never cause any collisions (which would
> - * decrease the uncertainty).
> - *
> - * Our mixing functions were analyzed by Lacharme, Roeck, Strubel, and
> - * Videau in their paper, "The Linux Pseudorandom Number Generator
> - * Revisited" (see: http://eprint.iacr.org/2012/251.pdf).  In their
> - * paper, they point out that we are not using a true Twisted GFSR,
> - * since Matsumoto & Kurita used a trinomial feedback polynomial (that
> - * is, with only three taps, instead of the six that we are using).
> - * As a result, the resulting polynomial is neither primitive nor
> - * irreducible, and hence does not have a maximal period over
> - * GF(2**32).  They suggest a slight change to the generator
> - * polynomial which improves the resulting TGFSR polynomial to be
> - * irreducible, which we have made here.
> - */
>  enum poolinfo {
> -       POOL_WORDS =3D 128,
> -       POOL_WORDMASK =3D POOL_WORDS - 1,
> -       POOL_BYTES =3D POOL_WORDS * sizeof(u32),
> -       POOL_BITS =3D POOL_BYTES * 8,
> +       POOL_BITS =3D BLAKE2S_HASH_SIZE * 8,
>         POOL_BITSHIFT =3D ilog2(POOL_BITS),
>
>         /* To allow fractional bits to be tracked, the entropy_count fiel=
d is
>          * denominated in units of 1/8th bits. */
>         POOL_ENTROPY_SHIFT =3D 3,
>  #define POOL_ENTROPY_BITS() (input_pool.entropy_count >> POOL_ENTROPY_SH=
IFT)
> -       POOL_FRACBITS =3D POOL_BITS << POOL_ENTROPY_SHIFT,
> -
> -       /* x^128 + x^104 + x^76 + x^51 +x^25 + x + 1 */
> -       POOL_TAP1 =3D 104,
> -       POOL_TAP2 =3D 76,
> -       POOL_TAP3 =3D 51,
> -       POOL_TAP4 =3D 25,
> -       POOL_TAP5 =3D 1,
> -
> -       EXTRACT_SIZE =3D BLAKE2S_HASH_SIZE / 2
> +       POOL_FRACBITS =3D POOL_BITS << POOL_ENTROPY_SHIFT
>  };
>
>  /*
> @@ -438,6 +302,12 @@ enum poolinfo {
>   */
>  static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
>  static struct fasync_struct *fasync;
> +/*
> + * If the entropy count falls under this number of bits, then we
> + * should wake up processes which are selecting or polling on write
> + * access to /dev/random.
> + */
> +static int random_write_wakeup_bits =3D POOL_BITS * 3 / 4;
>
>  static DEFINE_SPINLOCK(random_ready_list_lock);
>  static LIST_HEAD(random_ready_list);
> @@ -493,73 +363,31 @@ MODULE_PARM_DESC(ratelimit_disable, "Disable random=
 ratelimit suppression");
>   *
>   **********************************************************************/
>
> -static u32 input_pool_data[POOL_WORDS] __latent_entropy;
> -
>  static struct {
> +       struct blake2s_state hash;
>         spinlock_t lock;
> -       u16 add_ptr;
> -       u16 input_rotate;
>         int entropy_count;
>  } input_pool =3D {
> +       .hash.h =3D { BLAKE2S_IV0 ^ (0x01010000 | BLAKE2S_HASH_SIZE),
> +                   BLAKE2S_IV1, BLAKE2S_IV2, BLAKE2S_IV3, BLAKE2S_IV4,
> +                   BLAKE2S_IV5, BLAKE2S_IV6, BLAKE2S_IV7 },
> +       .hash.outlen =3D BLAKE2S_HASH_SIZE,
>         .lock =3D __SPIN_LOCK_UNLOCKED(input_pool.lock),
>  };
>
> -static ssize_t extract_entropy(void *buf, size_t nbytes, int min);
> -static ssize_t _extract_entropy(void *buf, size_t nbytes);
> +static bool extract_entropy(void *buf, size_t nbytes, int min);
> +static void _extract_entropy(void *buf, size_t nbytes);
>
>  static void crng_reseed(struct crng_state *crng, bool use_input_pool);
>
> -static const u32 twist_table[8] =3D {
> -       0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
> -       0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
> -
>  /*
>   * This function adds bytes into the entropy "pool".  It does not
>   * update the entropy estimate.  The caller should call
>   * credit_entropy_bits if this is appropriate.
> - *
> - * The pool is stirred with a primitive polynomial of the appropriate
> - * degree, and then twisted.  We twist by three bits at a time because
> - * it's cheap to do so and helps slightly in the expected case where
> - * the entropy is concentrated in the low-order bits.
>   */
>  static void _mix_pool_bytes(const void *in, int nbytes)
>  {
> -       unsigned long i;
> -       int input_rotate;
> -       const u8 *bytes =3D in;
> -       u32 w;
> -
> -       input_rotate =3D input_pool.input_rotate;
> -       i =3D input_pool.add_ptr;
> -
> -       /* mix one byte at a time to simplify size handling and churn fas=
ter */
> -       while (nbytes--) {
> -               w =3D rol32(*bytes++, input_rotate);
> -               i =3D (i - 1) & POOL_WORDMASK;
> -
> -               /* XOR in the various taps */
> -               w ^=3D input_pool_data[i];
> -               w ^=3D input_pool_data[(i + POOL_TAP1) & POOL_WORDMASK];
> -               w ^=3D input_pool_data[(i + POOL_TAP2) & POOL_WORDMASK];
> -               w ^=3D input_pool_data[(i + POOL_TAP3) & POOL_WORDMASK];
> -               w ^=3D input_pool_data[(i + POOL_TAP4) & POOL_WORDMASK];
> -               w ^=3D input_pool_data[(i + POOL_TAP5) & POOL_WORDMASK];
> -
> -               /* Mix the result back in with a twist */
> -               input_pool_data[i] =3D (w >> 3) ^ twist_table[w & 7];
> -
> -               /*
> -                * Normally, we add 7 bits of rotation to the pool.
> -                * At the beginning of the pool, add an extra 7 bits
> -                * rotation, so that successive passes spread the
> -                * input bits across the pool evenly.
> -                */
> -               input_rotate =3D (input_rotate + (i ? 7 : 14)) & 31;
> -       }
> -
> -       input_pool.input_rotate =3D input_rotate;
> -       input_pool.add_ptr =3D i;
> +       blake2s_update(&input_pool.hash, in, nbytes);
>  }
>
>  static void __mix_pool_bytes(const void *in, int nbytes)
> @@ -953,15 +781,14 @@ static int crng_slow_load(const u8 *cp, size_t len)
>  static void crng_reseed(struct crng_state *crng, bool use_input_pool)
>  {
>         unsigned long flags;
> -       int i, num;
> +       int i;
>         union {
>                 u8 block[CHACHA_BLOCK_SIZE];
>                 u32 key[8];
>         } buf;
>
>         if (use_input_pool) {
> -               num =3D extract_entropy(&buf, 32, 16);
> -               if (num =3D=3D 0)
> +               if (!extract_entropy(&buf, 32, 16))
>                         return;
>         } else {
>                 _extract_crng(&primary_crng, buf.block);
> @@ -1329,74 +1156,48 @@ static size_t account(size_t nbytes, int min)
>  }
>
>  /*
> - * This function does the actual extraction for extract_entropy.
> - *
> - * Note: we assume that .poolwords is a multiple of 16 words.
> + * This is an HKDF-like construction for using the hashed collected entr=
opy
> + * as a PRF key, that's then expanded block-by-block.
>   */
> -static void extract_buf(u8 *out)
> +static void _extract_entropy(void *buf, size_t nbytes)
>  {
> -       struct blake2s_state state __aligned(__alignof__(unsigned long));
> -       u8 hash[BLAKE2S_HASH_SIZE];
> -       unsigned long *salt;
>         unsigned long flags;
> -
> -       blake2s_init(&state, sizeof(hash));
> -
> -       /*
> -        * If we have an architectural hardware random number
> -        * generator, use it for BLAKE2's salt & personal fields.
> -        */
> -       for (salt =3D (unsigned long *)&state.h[4];
> -            salt < (unsigned long *)&state.h[8]; ++salt) {
> -               unsigned long v;
> -               if (!arch_get_random_long(&v))
> -                       break;
> -               *salt ^=3D v;
> +       u8 seed[BLAKE2S_HASH_SIZE], next_key[BLAKE2S_HASH_SIZE];
> +       struct {
> +               unsigned long rdrand[32 / sizeof(long)];
> +               size_t counter;
> +       } block;
> +       size_t i;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(block.rdrand); ++i) {
> +               if (!arch_get_random_long(&block.rdrand[i]))
> +                       block.rdrand[i] =3D random_get_entropy();
>         }
>
> -       /* Generate a hash across the pool */
>         spin_lock_irqsave(&input_pool.lock, flags);
> -       blake2s_update(&state, (const u8 *)input_pool_data, POOL_BYTES);
> -       blake2s_final(&state, hash); /* final zeros out state */
>
> -       /*
> -        * We mix the hash back into the pool to prevent backtracking
> -        * attacks (where the attacker knows the state of the pool
> -        * plus the current outputs, and attempts to find previous
> -        * outputs), unless the hash function can be inverted. By
> -        * mixing at least a hash worth of hash data back, we make
> -        * brute-forcing the feedback as hard as brute-forcing the
> -        * hash.
> -        */
> -       __mix_pool_bytes(hash, sizeof(hash));
> -       spin_unlock_irqrestore(&input_pool.lock, flags);
> +       /* seed =3D HASHPRF(last_key, entropy_input) */
> +       blake2s_final(&input_pool.hash, seed);
>
> -       /* Note that EXTRACT_SIZE is half of hash size here, because abov=
e
> -        * we've dumped the full length back into mixer. By reducing the
> -        * amount that we emit, we retain a level of forward secrecy.
> -        */
> -       memcpy(out, hash, EXTRACT_SIZE);
> -       memzero_explicit(hash, sizeof(hash));
> -}
> +       /* next_key =3D HASHPRF(seed, RDRAND || 0) */
> +       block.counter =3D 0;
> +       blake2s(next_key, (u8 *)&block, seed, sizeof(next_key), sizeof(bl=
ock), sizeof(seed));
> +       blake2s_init_key(&input_pool.hash, BLAKE2S_HASH_SIZE, next_key, s=
izeof(next_key));
>
> -static ssize_t _extract_entropy(void *buf, size_t nbytes)
> -{
> -       ssize_t ret =3D 0, i;
> -       u8 tmp[EXTRACT_SIZE];
> +       spin_unlock_irqrestore(&input_pool.lock, flags);
> +       memzero_explicit(next_key, sizeof(next_key));
>
>         while (nbytes) {
> -               extract_buf(tmp);
> -               i =3D min_t(int, nbytes, EXTRACT_SIZE);
> -               memcpy(buf, tmp, i);
> +               i =3D min_t(size_t, nbytes, BLAKE2S_HASH_SIZE);
> +               /* output =3D HASHPRF(seed, RDRAND || ++counter) */
> +               ++block.counter;
> +               blake2s(buf, (u8 *)&block, seed, i, sizeof(block), sizeof=
(seed));
>                 nbytes -=3D i;
>                 buf +=3D i;
> -               ret +=3D i;
>         }
>
> -       /* Wipe data just returned from memory */
> -       memzero_explicit(tmp, sizeof(tmp));
> -
> -       return ret;
> +       memzero_explicit(seed, sizeof(seed));
> +       memzero_explicit(&block, sizeof(block));
>  }
>
>  /*
> @@ -1404,13 +1205,18 @@ static ssize_t _extract_entropy(void *buf, size_t=
 nbytes)
>   * returns it in a buffer.
>   *
>   * The min parameter specifies the minimum amount we can pull before
> - * failing to avoid races that defeat catastrophic reseeding.
> + * failing to avoid races that defeat catastrophic reseeding. If we
> + * have less than min entropy available, we return false and buf is
> + * not filled.
>   */
> -static ssize_t extract_entropy(void *buf, size_t nbytes, int min)
> +static bool extract_entropy(void *buf, size_t nbytes, int min)
>  {
>         trace_extract_entropy(nbytes, POOL_ENTROPY_BITS(), _RET_IP_);
> -       nbytes =3D account(nbytes, min);
> -       return _extract_entropy(buf, nbytes);
> +       if (account(nbytes, min)) {
> +               _extract_entropy(buf, nbytes);
> +               return true;
> +       }
> +       return false;
>  }
>
>  #define warn_unseeded_randomness(previous) \
> @@ -1674,7 +1480,7 @@ static void __init init_std_data(void)
>         unsigned long rv;
>
>         mix_pool_bytes(&now, sizeof(now));
> -       for (i =3D POOL_BYTES; i > 0; i -=3D sizeof(rv)) {
> +       for (i =3D BLAKE2S_BLOCK_SIZE; i > 0; i -=3D sizeof(rv)) {
>                 if (!arch_get_random_seed_long(&rv) &&
>                     !arch_get_random_long(&rv))
>                         rv =3D random_get_entropy();
> --
> 2.34.1
>
